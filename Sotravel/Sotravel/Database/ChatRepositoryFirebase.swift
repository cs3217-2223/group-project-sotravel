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

    // MARK: FOR CHAT PAGE CELLS
    func getBasicInfo(for id: Int, completion: @escaping ((Chat) -> Void)) {
        let databasePath = databaseRef.child("chats/\(id)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let key = snapshot?.key, var json = snapshot?.value as? [String: Any] else {
                let chat = Chat(id: id)
                completion(chat)
                return
            }
            do { // TODO: see if need to change to accommodate 3 messages
                json["id"] = key
                let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                guard let messageId = chatBasicInfoAM.lastMessage, !messageId.isEmpty else {
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM)
                    completion(chat)
                    return
                }
                self.getChatMessageAM(chatId: id, messageId: messageId, completion: { chatMessageAM in
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM,
                                                           chatMessageAMs: [chatMessageAM])
                    completion(chat)
                })
            } catch {
                print("An error occurred", error)
            }
        })
    }

    private func getChatMessageAM(chatId: Int, messageId: String,
                                  completion: @escaping ((ChatMessageApiModel) -> Void)) {
        let databasePath = databaseRef.child("messages/\(chatId)/\(messageId)")
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
                completion(chatMessageAM)
            } catch {
                guard let data = json[messageId] else {
                    return
                }
                do {
                    let chatMessageAMData = try JSONSerialization.data(withJSONObject: data)
                    let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
                    completion(chatMessageAM)
                } catch {
                    print("An error occurred", error)
                }
            }
        })
    }

    // MARK: FOR CHAT PAGE (SINGLE)
    func getChat(id: Int, completion: @escaping ((Chat) -> Void)) {
        getChatMessageAMs(id: id, completion: { chatMessageAMs in
            let chatMessages = chatMessageAMs.map { self.convertChatMessageAMToChatMessage(chatMessageAM: $0) }
            let chat = Chat(id: id, messages: chatMessages)
            completion(chat)
        })
    }

    private func getChatMessageAMs(id: Int, completion: @escaping (([ChatMessageApiModel]) -> Void)) {
        let databasePath = self.databaseRef.child("messages/\(id)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsons = snapshot?.value as? [String: Any] else {
                // no chat messages
                completion([])
                return
            }
            var chatMessageAMs = [ChatMessageApiModel]()
            for json in jsons {
                let data = json.value
                do {
                    let chatMessageAMData = try JSONSerialization.data(withJSONObject: data)
                    let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
                    chatMessageAMs.append(chatMessageAM)
                } catch {
                    print("An error occurred", error)
                }
            }
            completion(chatMessageAMs)
        })
    }

    // MARK: FOR SENDING CHAT MESSAGES
    func sendChatMessage(chatMessage: ChatMessage, to chatId: Int) -> Bool {
        if !addChatMessage(chatMessage: chatMessage, chatId: chatId) {
            return false
        }
        updateChatBasicInfo(chatMessage: chatMessage, chatId: chatId)
        return true
    }

    private func addChatMessage(chatMessage: ChatMessage, chatId: Int) -> Bool {
        let databasePath = databaseRef.child("messages/\(chatId)")
        do {
            let data = try encoder.encode(chatMessage)
            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.child(chatMessage.id.uuidString).setValue(json)
        } catch {
            print("An error occurred", error)
            return false
        }
        return true
    }

    private func updateChatBasicInfo(chatMessage: ChatMessage, chatId: Int) {
        getLastThreeMessages(for: chatId, completion: { messageIds in
            var update: [String: String] = [:]
            if messageIds.isEmpty { // just update for last message
                update = ["lastMessage": chatMessage.id.uuidString]
            } else if messageIds.count == 1 { // update for last and second last message
                update = ["lastMessage": chatMessage.id.uuidString,
                          "secondLastMessage": messageIds[0]]
            } else if messageIds.count == 2 { // update for all 3 messages
                update = ["lastMessage": chatMessage.id.uuidString,
                          "secondLastMessage": messageIds[0],
                          "thirdLastMessage": messageIds[1]]
            }
            self.updateChatBasicInfoValues(chatId: chatId, update: update)
        })
    }

    private func updateChatBasicInfoValues(chatId: Int, update: [String: String]) {
        let databasePath = databaseRef.child("chats/\(chatId)")
        databasePath.updateChildValues(update)
    }

    private func getLastThreeMessages(for id: Int, completion: @escaping (([String]) -> Void)) {
        let databasePath = databaseRef.child("chats/\(id)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let key = snapshot?.key, var json = snapshot?.value as? [String: Any] else { // no messages
                completion([])
                return
            }
            do {
                json["id"] = key
                let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                guard let lastMessageId = chatBasicInfoAM.lastMessage, !lastMessageId.isEmpty else { // no messages
                    completion([])
                    return
                }
                guard let secondLastMessageId = chatBasicInfoAM.secondLastMessage,
                      !secondLastMessageId.isEmpty else { // only have last message
                    completion([lastMessageId])
                    return
                }
                completion([lastMessageId, secondLastMessageId]) // have both last and second last messages
            } catch {
                print("An error occurred", error)
            }
        })
    }

    // MARK: FOR CHAT PREVIEW
    func getChatPreview(for id: Int, completion: @escaping ((Chat) -> Void)) {
        // TODO: refactor (with getBasicInfo)
        let databasePath = databaseRef.child("chats/\(id)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let key = snapshot?.key, var json = snapshot?.value as? [String: Any] else {
                let chat = Chat(id: id)
                completion(chat)
                return
            }
            do {
                json["id"] = key
                let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                // check for lastMessage
                guard let lastMessageId = chatBasicInfoAM.lastMessage, !lastMessageId.isEmpty else {
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM)
                    completion(chat)
                    return
                }
                // convert lastMessage
                self.getChatMessageAM(chatId: id, messageId: lastMessageId, completion: { lastChatMessageAM in
                    // check for secondLastMessage
                    guard let secondLastMessageId = chatBasicInfoAM.secondLastMessage,
                          !secondLastMessageId.isEmpty else {
                        let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM,
                                                               chatMessageAMs: [lastChatMessageAM])
                        completion(chat)
                        return
                    }
                    // convert secondLastMessage
                    self.getChatMessageAM(chatId: id, messageId: secondLastMessageId, completion: { secondLastChatMessageAM in
                        // check for thirdLastMessage
                        guard let thirdLastMessageId = chatBasicInfoAM.thirdLastMessage,
                              !thirdLastMessageId.isEmpty else {
                            let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM,
                                                                   chatMessageAMs: [secondLastChatMessageAM, lastChatMessageAM])
                            completion(chat)
                            return
                        }
                        // convert thirdLastMessage
                        self.getChatMessageAM(chatId: id, messageId: thirdLastMessageId, completion: { thirdLastChatMessageAM in
                            let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM,
                                                                   chatMessageAMs: [thirdLastChatMessageAM,
                                                                                    secondLastChatMessageAM,
                                                                                    lastChatMessageAM])
                            completion(chat)
                        })
                    })
                })
            } catch {
                print("An error occurred", error)
            }
        })
    }

    // MARK: FOR LISTENERS
    func setListenerForChatMessages(for chatId: Int, completion: @escaping ((ChatMessage) -> Void)) {
        let databasePath = databaseRef.child("messages/\(chatId)")
        databasePath.observe(.childAdded, with: { snapshot in
            guard let json = snapshot.value as? [String: Any] else {
                return
            }
            do {
                let chatMessageAMData = try JSONSerialization.data(withJSONObject: json)
                let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
                let chatMessage = self.convertChatMessageAMToChatMessage(chatMessageAM: chatMessageAM)
                completion(chatMessage)
            } catch {
                print("An error occurred", error)
            }
        })
    }

    func removeListenerForChatMessages(for chatId: Int) {
        let databasePath = databaseRef.child("messages/\(chatId)")
        databasePath.removeAllObservers()
    }

    // TODO: see if need to change to accommodate 3 messages
    func setListenerForChatBasicInfo(for chatId: Int, completion: @escaping ((Chat) -> Void)) {
        print("Setting listener for \(chatId)")
        let databasePath = databaseRef.child("chats/\(chatId)")
        databasePath.observe(.value, with: { snapshot in
            guard var json = snapshot.value as? [String: Any] else {
                return
            }
            do {
                let key = snapshot.key
                json["id"] = key
                let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                guard let messageId = chatBasicInfoAM.lastMessage, !messageId.isEmpty else {
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM)
                    completion(chat)
                    return
                }
                self.getChatMessageAM(chatId: chatId, messageId: messageId, completion: { chatMessageAM in
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM,
                                                           chatMessageAMs: [chatMessageAM])
                    completion(chat)
                })
            } catch {
                print("An error occurred", error)
            }
        })
    }

    func removeListenerForChatBasicInfo(for chatId: Int) {
        let databasePath = databaseRef.child("chats/\(chatId)")
        databasePath.removeAllObservers()
    }
}

// MARK: CONVERTERS
extension ChatRepositoryFirebase {
    func convertApiModelsToChat(chatBasicInfoAM: ChatBasicInfoApiModel,
                                chatMessageAMs: [ChatMessageApiModel] = []) -> Chat {
        let chatMessages = chatMessageAMs.map { convertChatMessageAMToChatMessage(chatMessageAM: $0) }
        return Chat(id: Int(chatBasicInfoAM.id ?? "-1") ?? -1, messages: chatMessages)
    }

    func convertChatMessageAMToChatMessage(chatMessageAM: ChatMessageApiModel) -> ChatMessage {
        ChatMessage(id: UUID(uuidString: chatMessageAM.id ?? "") ?? UUID(),
                    messageText: chatMessageAM.messageText ?? "",
                    timestamp: Date(timeIntervalSinceReferenceDate: chatMessageAM.timestamp),
                    sender: UUID(uuidString: chatMessageAM.sender ?? "") ?? UUID())
    }
}
