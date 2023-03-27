//
//  ChatRepositoryFirebase.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 25/3/23.
//

import Foundation

class ChatRepositoryFirebase: ChatRepository {
    func getBasicInfoChats(userId: UUID) -> [Chat] {
        // TODO: actual implementation - get api model from db, convert to model
        let chat1message = ChatMessage(messageText: "c1m4", timestamp: Date.now, sender: mockNotMe.id)
        let chat1 = Chat(messages: [chat1message], title: "chat1", members: [])
        chat1.id = UUID(uuidString: "1B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID()
        let chat2message = ChatMessage(messageText: "c2m1", timestamp: Date.now, sender: mockMe.id)
        let chat2 = Chat(messages: [chat2message], title: "chat2", members: [])
        chat2.id = UUID(uuidString: "2B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID()
        let chat3message = ChatMessage(messageText: "c3m1", timestamp: Date.now, sender: mockMe.id)
        let chat3 = Chat(messages: [chat3message], title: "chat3", members: [])
        chat3.id = UUID(uuidString: "3B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID()
        return [chat1, chat2, chat3]
    }

    func getChat(chatId: UUID) -> Chat {
        // TODO: actual implementation - get api model from db, convert to model
        let message1 = ChatMessage(messageText: "c1m1", timestamp: Date.now, sender: mockMe.id)
        let message2 = ChatMessage(messageText: "c1m2", timestamp: Date.now, sender: mockNotMe.id)
        let message3 = ChatMessage(messageText: "c1m3", timestamp: Date.now, sender: mockMe.id)
        let message4 = ChatMessage(messageText: "c1m4", timestamp: Date.now, sender: mockNotMe.id)
        let chat = Chat(messages: [message1, message2, message3, message4],
                        members: [mockMe, mockNotMe],
                        event: mockEvent1)
        return chat
    }

    func sendChatMessage(chatMessage: ChatMessage, chatId: UUID) -> Bool {
        // TODO: actual implementation - convert to api model and send to db for storage
        return true
    }
}
