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
    var chatId: UUID?
    @Published var chatPageCellVMs: [ChatPageCellViewModel]
    @Published var chatHeaderVM: ChatHeaderViewModel
    @Published var chatMessageVMs: [ChatMessageViewModel]
    var isNewChatListenerSet = false

    @Injected private var chatRepository: ChatRepository

    init() {
        self.chatPageCellVMs = []
        self.chatHeaderVM = ChatHeaderViewModel()
        self.chatMessageVMs = []
    }

    func setUserId(user: User?) {
        guard let user = user else {
            return
        }
        userId = user.id
    }

    func fetchChatPageCells() {
        guard let id = userId else {
            return
        }

        chatRepository.getBasicInfoChats(userId: id, completion: { basicChat in
            let mappedChatVM = ChatPageCellViewModel(chatTitle: basicChat.title,
                                                     lastMessageText: basicChat.messages.last?.messageText,
                                                     lastMessageSender: basicChat.messages.last?.sender.uuidString,
                                                     lastMessageDate: basicChat.messages.last?.timestamp,
                                                     id: basicChat.id)
            self.chatPageCellVMs.append(mappedChatVM)
            // TODO: sort by timestamp, latest in front ... want to maintain sorted array

            self.chatRepository.setListenerForChatBasicInfo(for: basicChat.id, completion: { updatedChat in
                guard let chatPageCellVMToUpdate = self.chatPageCellVMs.first(where: { $0.id == updatedChat.id }) else {
                    return
                }
                let updatedVM = ChatPageCellViewModel(chatTitle: updatedChat.title,
                                                      lastMessageText: updatedChat.messages.last?.messageText,
                                                      lastMessageSender: updatedChat.messages.last?.sender.uuidString,
                                                      lastMessageDate: updatedChat.messages.last?.timestamp,
                                                      id: updatedChat.id)
                chatPageCellVMToUpdate.update(with: updatedVM)
            })

            if !self.isNewChatListenerSet {
                self.isNewChatListenerSet = true
                self.setListenerForAddedChat(userId: id)
            }
        })

    }

    private func setListenerForAddedChat(userId: UUID) {
        chatRepository.setListenerForAddedChat(userId: userId, completion: { newChat in
            let chatPageCellVM = ChatPageCellViewModel(chatTitle: newChat.title,
                                                       lastMessageText: newChat.messages.last?.messageText,
                                                       lastMessageSender: newChat.messages.last?.sender.uuidString,
                                                       lastMessageDate: newChat.messages.last?.timestamp,
                                                       id: newChat.id)
            if self.chatPageCellVMs.contains(where: { $0.id == newChat.id }) {
                return
            }
            self.chatPageCellVMs.append(chatPageCellVM)
        })
    }

    func fetchChat(id: UUID) {
        guard let userId = userId else {
            return
        }
        chatId = id

        chatRepository.getChat(chatId: id, completion: { chat in
            if let eventId = chat.eventId {
                // TODO: pass eventId and get datetime from eventService in the view
                self.chatHeaderVM = ChatHeaderViewModel(chatTitle: chat.title)
            } else {
                self.chatHeaderVM = ChatHeaderViewModel(chatTitle: chat.title)
            }

            // TODO: convert sender uuid to image src and name (through user service?)
            self.chatMessageVMs = chat.messages.map {
                ChatMessageViewModel(messageText: $0.messageText,
                                     messageTimestamp: $0.timestamp,
                                     senderId: $0.sender,
                                     senderImageSrc: $0.sender.uuidString,
                                     senderName: $0.sender.uuidString,
                                     isSentByMe: $0.sender == userId,
                                     id: $0.id) // TODO: sort by timestamp, earliest in front
            }

            self.chatRepository.setListenerForChatMessages(for: id, completion: { chatMessage in
                // TODO: convert sender uuid to image src and name (through user service?)
                let chatMessageVM = ChatMessageViewModel(messageText: chatMessage.messageText,
                                                         messageTimestamp: chatMessage.timestamp,
                                                         senderId: chatMessage.sender,
                                                         senderImageSrc: chatMessage.sender.uuidString,
                                                         senderName: chatMessage.sender.uuidString,
                                                         isSentByMe: chatMessage.sender == userId,
                                                         id: chatMessage.id)
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
        return chatRepository.sendChatMessage(chatMessage: chatMessage, chatId: chatId)
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

    // TODO: addEventChat(eventId: int)
}
