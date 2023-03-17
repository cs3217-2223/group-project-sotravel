//
//  ChatViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 17/3/23.
//

import Foundation

class ChatViewModel: ChatViewModelDelegate {
    func sendChatMessage(messageText: String, sender: User, toChat chat: Chat) -> Bool {
        let newChatMessage = ChatMessage(messageText: messageText, timestamp: Date.now, sender: sender)
        chat.addChatMessage(newChatMessage)
        // TODO: db to store the chat message
        return true
    }
}
