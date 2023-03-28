//
//  ChatRepositoryFirebase.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 25/3/23.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class ChatRepositoryFirebase: ChatRepository {
    private let databaseRef = Database.database().reference()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func getBasicInfoChats(userId: UUID, completion: @escaping ((Chat) -> Void)) {
        getChatBasicInfoWithMessageAMs(userId: userId, completion: { chatBasicInfoWithMessageAM in
            guard let lastMessage: ChatMessageApiModel = chatBasicInfoWithMessageAM.lastMessage else {
                let chat = Chat(id: UUID(uuidString: chatBasicInfoWithMessageAM.id ?? "") ?? UUID(),
                                messages: [],
                                title: chatBasicInfoWithMessageAM.title ?? "",
                                members: [])
                completion(chat)
                return
            }
            let message = ChatMessage(id: UUID(uuidString: lastMessage.id ?? "") ?? UUID(),
                                      messageText: lastMessage.messageText ?? "",
                                      timestamp: Date(timeIntervalSinceReferenceDate: lastMessage.timestamp),
                                      sender: UUID(uuidString: lastMessage.sender ?? "") ?? UUID())

            let chat = Chat(id: UUID(uuidString: chatBasicInfoWithMessageAM.id ?? "") ?? UUID(),
                            messages: [message],
                            title: chatBasicInfoWithMessageAM.title ?? "",
                            members: [])
            completion(chat)
        })
    }

    private func getChatBasicInfoWithMessageAMs(userId: UUID,
                                                completion: @escaping ((ChatBasicInfoWithMessageApiModel) -> Void)) {
        getBasicInfoChatAMs(userId: userId, completion: { chatBasicInfoAM in
            guard let chatId = chatBasicInfoAM.id, let messageId = chatBasicInfoAM.lastMessage else {
                return
            }
            if messageId.isEmpty {
                let chatBasicInfoWithMessageAM = ChatBasicInfoWithMessageApiModel(id: chatBasicInfoAM.id,
                                                                                  title: chatBasicInfoAM.title,
                                                                                  lastMessage: nil)
                completion(chatBasicInfoWithMessageAM)
                return
            }

            let databasePath = self.databaseRef.child("messages/\(chatId)/\(messageId)")
            databasePath.getData(completion: { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let json = snapshot?.value as? [String: Any] else {
                    return
                }
                do {
                    let chatMessageAMData = try JSONSerialization.data(withJSONObject: json)
                    let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
                    let chatBasicInfoWithMessageAM = ChatBasicInfoWithMessageApiModel(id: chatBasicInfoAM.id,
                                                                                      title: chatBasicInfoAM.title,
                                                                                      lastMessage: chatMessageAM)
                    completion(chatBasicInfoWithMessageAM)
                } catch {
                    print("An error occurred", error)
                }
            })
        })
    }

    private func getBasicInfoChatAMs(userId: UUID, completion: @escaping ((ChatBasicInfoApiModel) -> Void)) {
        getChatIds(userId: userId, completion: { chatId in
            let databasePath = self.databaseRef.child("chats/\(chatId)")
            databasePath.getData(completion: { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let json = snapshot?.value as? [String: Any] else {
                    return
                }
                do {
                    let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                    let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                    completion(chatBasicInfoAM)
                } catch {
                    print("An error occurred", error)
                }
            })
        })
    }

    private func getChatIds(userId: UUID, completion: @escaping ((String) -> Void)) {
        let databasePath = self.databaseRef.child("userChats/\(userId.uuidString)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsons = snapshot?.value as? [String: String] else {
                return
            }
            for json in jsons {
                let chatId = json.value
                completion(chatId)
            }
        })
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
