//
//  ChatService.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation
import Resolver
// import Combine

class ChatService: ObservableObject {
    var userId: UUID?
    var chatId: UUID?
    @Published var chatPageCellVMs: [ChatPageCellViewModel]
    @Published var chatHeaderVM: ChatHeaderViewModel
    @Published var chatMessageVMs: [ChatMessageViewModel]

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
            self.chatPageCellVMs.append(mappedChatVM) // TODO: sort?
        })
    }

    func fetchChat(id: UUID) {
        guard let userId = userId else {
            return
        }
        chatId = id

        chatRepository.getChat(chatId: id, completion: { chat in
            if let event = chat.event {
                self.chatHeaderVM = ChatHeaderViewModel(chatTitle: chat.title, eventDatetime: event.datetime)
            } else {
                self.chatHeaderVM = ChatHeaderViewModel(chatTitle: chat.title)
            }

            // TODO: convert sender uuid to image src and name (through user service?)
            self.chatMessageVMs = chat.messages.map {
                ChatMessageViewModel(messageText: $0.messageText,
                                     messageTimestamp: $0.timestamp,
                                     senderImageSrc: $0.sender.uuidString,
                                     senderName: $0.sender.uuidString,
                                     isSentByMe: $0.sender == userId,
                                     id: $0.id)
            }
        })
    }

    // to check the realtime update thingy
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
}
