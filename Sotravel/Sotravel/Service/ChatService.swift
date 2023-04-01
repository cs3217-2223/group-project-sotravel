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
    var isChatPageCellListenerSet: [Int: Bool] = [:]

    @Injected private var chatRepository: ChatRepository

    init() {
        self.chatPageCellVMs = []
        self.chatHeaderVM = ChatHeaderViewModel()
        self.chatMessageVMs = []
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
            // TODO: sort by timestamp, latest in front ... want to maintain sorted array
            self.chatPageCellVMs.append(chatPageCellVM)

            if self.isChatPageCellListenerSet[id] ?? false {
                return
            }

            self.chatRepository.setListenerForChatBasicInfo(for: id, completion: { updatedChat in
                guard let chatPageCellVMToUpdate = self.chatPageCellVMs.first(where: { ($0.id ?? -1) == updatedChat.id }) else {
                    return
                }
                let updatedVM = self.convertChatToChatPageCellVM(chat: updatedChat)
                chatPageCellVMToUpdate.update(with: updatedVM)
            })

            self.isChatPageCellListenerSet[id] = true
        })
    }

    func fetchChat(id: Int?) {
        guard let userId = userId, let id = id else {
            return
        }
        chatId = id

        chatRepository.getChat(id: id, completion: { chat in
            let chatHeaderVM = self.convertChatToChatHeaderVM(chat: chat)
            self.chatHeaderVM = chatHeaderVM

            let chatMessageVMs = chat.messages.map { self.convertChatMessageToChatMessageVM(chatMessage: $0,
                                                                                            userId: userId)
            }
            self.chatMessageVMs = chatMessageVMs

            self.chatRepository.setListenerForChatMessages(for: id, completion: { chatMessage in
                // TODO: sort by timestamp, latest behind ... want to maintain sorted array
                let chatMessageVM = self.convertChatMessageToChatMessageVM(chatMessage: chatMessage, userId: userId)
                self.chatMessageVMs.append(chatMessageVM)
            })
        })
    }

    func dismissChat() {
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
        return message.messageTimestamp.timeIntervalSince(previousMessage.messageTimestamp) > 60
    }

    func clear() {
        chatId = nil
        chatPageCellVMs = []
        chatHeaderVM = ChatHeaderViewModel()
        chatMessageVMs = []
        isChatPageCellListenerSet = [:]
        // TODO: remove listeners for current chatId and all ids in the chat page cell VMs
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
        ChatHeaderViewModel(chatTitle: "to delete - get from event service", eventId: chat.id)
    }

    private func convertChatMessageToChatMessageVM(chatMessage: ChatMessage, userId: UUID) -> ChatMessageViewModel {
        ChatMessageViewModel(messageText: chatMessage.messageText,
                             messageTimestamp: chatMessage.timestamp,
                             senderId: chatMessage.sender,
                             senderImageSrc: chatMessage.sender.uuidString, // TODO: delete this field
                             senderName: chatMessage.sender.uuidString, // TODO: delete this field
                             isSentByMe: chatMessage.sender == userId,
                             id: chatMessage.id)
    }
}

// MARK: temp for safekeeping
extension ChatService {
    // if needed, need to check if the chat is something the user should see before adding
    //    private func setListenerForAddedChat(userId: UUID) {
    //        chatRepository.setListenerForAddedChat(userId: userId, completion: { newChat in
    //            let chatPageCellVM = ChatPageCellViewModel(chatTitle: newChat.title,
    //                                                       lastMessageText: newChat.messages.last?.messageText,
    //                                                       lastMessageSender: newChat.messages.last?.sender.uuidString,
    //                                                       lastMessageDate: newChat.messages.last?.timestamp,
    //                                                       id: newChat.idUUID,
    //                                                       eventId: newChat.eventId)
    //            if self.chatPageCellVMs.contains(where: { $0.id == newChat.id }) {
    //                return
    //            }
    //            self.chatPageCellVMs.append(chatPageCellVM)
    //        })
    //    }
}
