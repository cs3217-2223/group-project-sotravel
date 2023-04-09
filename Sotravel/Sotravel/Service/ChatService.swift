//
//  ChatService.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation
import Resolver

class ChatService: ObservableObject {
    var userId: UUID?
    var chatId: Int?
    @Published var chatPageCellVMs: [ChatPageCellViewModel]
    @Published var chatHeaderVM: ChatHeaderViewModel
    @Published var chatMessageVMs: [ChatMessageViewModel]
    @Published var chatPreviewVM: ChatPreviewViewModel
    var isChatPageCellListenerSet: [Int: Bool] = [:]

    @Injected private var chatRepository: ChatRepository

    init() {
        self.chatPageCellVMs = []
        self.chatHeaderVM = ChatHeaderViewModel()
        self.chatMessageVMs = []
        self.chatPreviewVM = ChatPreviewViewModel()
    }

    func setUserId(userId: UUID) {
        self.userId = userId
    }

    func fetchChatPageCells(ids: [Int]) {
        for id in ids {
            if chatPageCellVMs.contains(where: { $0.id == id }) {
                continue
            }
            fetchChatPageCell(id: id)
        }
    }

    func fetchChatPageCell(id: Int) {
        chatRepository.getBasicInfo(for: id, completion: { basicChat in
            let chatPageCellVM = self.convertChatToChatPageCellVM(chat: basicChat)
            let index = self.chatPageCellVMs.insertionIndexOf(chatPageCellVM, isOrderedBefore: self.isOrderedBefore)
            self.chatPageCellVMs.insert(chatPageCellVM, at: index)

            if self.isChatPageCellListenerSet[id] ?? false {
                return
            }

            self.chatRepository.setListenerForChatBasicInfo(for: id, completion: { updatedChat in
                guard let chatPageCellVMToUpdate = self.chatPageCellVMs.first(where: { ($0.id ?? -1) == updatedChat.id }) else {
                    return
                }
                let updatedVM = self.convertChatToChatPageCellVM(chat: updatedChat)
                self.chatPageCellVMs.removeAll(where: { $0.id ?? -1 == updatedChat.id })
                let index = self.chatPageCellVMs.insertionIndexOf(updatedVM, isOrderedBefore: self.isOrderedBefore)
                self.chatPageCellVMs.insert(updatedVM, at: index)
            })

            self.isChatPageCellListenerSet[id] = true
        })
    }

    private func isOrderedBefore(element1: ChatPageCellViewModel, element2: ChatPageCellViewModel) -> Bool {
        guard let date1 = element1.lastMessageDate else { // no date, place behind
            return false
        }
        guard let date2 = element2.lastMessageDate else { // other has no date, place in front
            return true
        }
        return date1 > date2 // place in front if the last message came later
    }

    func removeChatPageCell(id: Int) {
        chatPageCellVMs.removeAll(where: { ($0.id ?? -1) == id })
        chatRepository.removeListenerForChatBasicInfo(for: id)
        isChatPageCellListenerSet[id] = false
    }

    func fetchChat(id: Int?) {
        guard let userId = userId, let id = id else {
            return
        }
        removeChatListener()
        chatId = id

        chatRepository.getChat(id: id, completion: { chat in
            let chatHeaderVM = self.convertChatToChatHeaderVM(chat: chat)
            self.chatHeaderVM = chatHeaderVM

            let chatMessageVMs = chat.messages.map { self.convertChatMessageToChatMessageVM(chatMessage: $0,
                                                                                            userId: userId)
            }
            self.chatMessageVMs = chatMessageVMs
            // for performance reasons, we can fetch data from firebase
            // sort it in an AMs array, then process 1 by 1 into the VMs array (see `fetchChatPageCell` above)
            // but leaving it like this for now
            self.chatMessageVMs.sort(by: { $0.messageTimestamp < $1.messageTimestamp })

            self.chatRepository.setListenerForChatMessages(for: id, completion: { chatMessage in
                if chatMessageVMs.contains(where: { $0.id == chatMessage.id }) {
                    return
                }
                let chatMessageVM = self.convertChatMessageToChatMessageVM(chatMessage: chatMessage, userId: userId)
                // should be appended in the order they enter the db, so it's fine
                self.chatMessageVMs.append(chatMessageVM)
            })
        })
    }

    func removeChatListener() {
        guard let chatId = chatId else {
            return
        }
        chatRepository.removeListenerForChatMessages(for: chatId)
    }

    func sendChatMessage(messageText: String) -> Bool {
        guard let userId = userId, let chatId = chatId else {
            return false
        }

        let chatMessage = ChatMessage(messageText: messageText, timestamp: Date.now, sender: userId)
        return chatRepository.sendChatMessage(chatMessage: chatMessage, to: chatId)
    }

    func shouldShowTimestampAboveMessage(for message: ChatMessageViewModel) -> Bool {
        guard let index = chatMessageVMs.firstIndex(where: { $0.id == message.id }) else {
            return false
        }

        if index == 0 {
            return true
        }

        let previousMessage = chatMessageVMs[index - 1]
        return message.messageTimestamp.timeIntervalSince(previousMessage.messageTimestamp) > 600 // 10 mins
    }

    func getEventPagePreview(eventId: Int) {
        chatRepository.getChatPreview(for: eventId, completion: { chatPreview in
            self.chatPreviewVM = self.convertChatToChatPreviewVM(chat: chatPreview)
        })
    }

    func clear() {
        removeAllListeners()
        resetAllStoredVMs()
    }

    func removeAllListeners() {
        removeChatListener()

        for chatPageCellVM in chatPageCellVMs {
            guard let id = chatPageCellVM.id else {
                continue
            }
            chatRepository.removeListenerForChatBasicInfo(for: id)
        }
        isChatPageCellListenerSet = [:]
    }

    func resetAllStoredVMs() {
        chatId = nil
        chatPageCellVMs = []
        chatHeaderVM = ChatHeaderViewModel()
        chatMessageVMs = []
        chatPreviewVM = ChatPreviewViewModel()
    }
}

// MARK: CONVERTERS
extension ChatService {
    private func convertChatToChatPageCellVM(chat: Chat) -> ChatPageCellViewModel {
        ChatPageCellViewModel(lastMessageText: chat.messages.last?.messageText,
                              lastMessageSender: chat.messages.last?.sender.uuidString,
                              lastMessageDate: chat.messages.last?.timestamp,
                              id: chat.id)
    }

    private func convertChatToChatHeaderVM(chat: Chat) -> ChatHeaderViewModel {
        ChatHeaderViewModel(eventId: chat.id)
    }

    private func convertChatMessageToChatMessageVM(chatMessage: ChatMessage, userId: UUID) -> ChatMessageViewModel {
        ChatMessageViewModel(messageText: chatMessage.messageText,
                             messageTimestamp: chatMessage.timestamp,
                             senderId: chatMessage.sender,
                             isSentByMe: chatMessage.sender == userId,
                             id: chatMessage.id)
    }

    private func convertChatToChatPreviewVM(chat: Chat) -> ChatPreviewViewModel {
        guard let userId = userId else {
            return ChatPreviewViewModel()
        }

        let chatMessageVMs = chat.messages.map { convertChatMessageToChatMessageVM(chatMessage: $0, userId: userId) }
        return ChatPreviewViewModel(lastMessageVMs: chatMessageVMs,
                                    id: chat.id)
    }
}
