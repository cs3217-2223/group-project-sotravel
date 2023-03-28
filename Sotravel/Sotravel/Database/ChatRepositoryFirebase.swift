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

    func getBasicInfoChats(userId: UUID) -> [Chat] {
        // TODO: get chat ids for the user
        let chatIds = getChatIds(userId: userId)

        // TODO: for each chat id, get the chat's basic info
        var chatBasicInfoAMs: [ChatBasicInfoApiModel] = []
        for chatId in chatIds {
            guard let chatBasicInfoAM = getBasicInfo(of: chatId) else {
                continue
            }
            chatBasicInfoAMs.append(chatBasicInfoAM)
        }

        // TODO: convert api model to model
        let basicInfoChats: [Chat] = []
        let databasePath = databaseRef.child("chats")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsons = snapshot?.value as? [String: Any] else {
                return
            }
            for json in jsons {
                let data = json.value
                do {
                    let chatBasicInfoData = try JSONSerialization.data(withJSONObject: data)
                    let chatBasicInfo = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoData)
                    // print(chatBasicInfo.title)
                    // TODO: api model to model
                } catch {
                    print("An error occurred", error)
                }
            }
        })

        return basicInfoChats
    }

    private func getBasicInfo(of chatId: String) -> ChatBasicInfoApiModel? {
        let databasePath = databaseRef.child("chats/\(chatId)")
        let chatBasicInfoAM: ChatBasicInfoApiModel? = nil
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let json = snapshot?.value as? [String: Any] else {
                return
            }
            print(json)
        })

        return chatBasicInfoAM
    }

    private func getChatIds(userId: UUID) -> [String] {
        let databasePath = databaseRef.child("userChats/\(userId.uuidString)")
        var chatIds: [String] = []

        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsons = snapshot?.value as? [String: String] else {
                return
            }
            for json in jsons {
                chatIds.append(json.value)
            }
        })

        return chatIds
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
