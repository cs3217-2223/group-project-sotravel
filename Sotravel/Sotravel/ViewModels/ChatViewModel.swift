//
//  ChatViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 17/3/23.
//

import Foundation
import FirebaseDatabase

class ChatViewModel: ChatViewModelDelegate, ObservableObject {
    var user: User
    var databaseConnector: DatabaseConnector

    init(user: User, databaseConnector: DatabaseConnector) {
        self.user = user
        self.databaseConnector = databaseConnector
    }

    func sendChatMessage(messageText: String, sender: User, toChat chat: Chat) -> Bool {
        let newChatMessage = ChatMessage(messageText: messageText, timestamp: Date.now, sender: sender.id)
        let success = databaseConnector.sendChatMessage(chatMessage: newChatMessage, chat: chat)
        if success {
            chat.addChatMessage(newChatMessage) // is this needed?
        }
        return success
    }

    func getSenderDetails(chatMessage: ChatMessage) -> User {
        // TODO: get from a method in the User model
        mockFriends.first { $0.id == chatMessage.sender } ?? user
    }

    func getSenderImage(chatMessage: ChatMessage) -> String {
        getSenderDetails(chatMessage: chatMessage).imageURL
    }

    func getSenderName(chatMessage: ChatMessage) -> String {
        getSenderDetails(chatMessage: chatMessage).name
    }
}
