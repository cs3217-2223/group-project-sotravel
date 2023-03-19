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
    private let databaseRef = Database.database().reference()
    private let encoder = JSONEncoder()

    init(user: User) {
        self.user = user
    }

    func sendChatMessage(messageText: String, sender: User, toChat chat: Chat) -> Bool {
        let newChatMessage = ChatMessage(messageText: messageText, timestamp: Date.now, sender: sender.id)
        chat.addChatMessage(newChatMessage)
        // TODO: db to store the chat message
        let databasePath = databaseRef.child("messages/\(chat.id)")
        do {
            let data = try encoder.encode(newChatMessage)
            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.childByAutoId().setValue(json)
        } catch {
            print("An error occurred", error)
            return false
        }
        return true
    }

    func getSenderDetails(chatMessage: ChatMessage) -> User {
        // TODO: temp
        mockFriends.first { $0.id == chatMessage.sender } ?? user
    }

    func getSenderImage(chatMessage: ChatMessage) -> String {
        getSenderDetails(chatMessage: chatMessage).imageURL
    }

    func getSenderName(chatMessage: ChatMessage) -> String {
        getSenderDetails(chatMessage: chatMessage).name
    }
}
