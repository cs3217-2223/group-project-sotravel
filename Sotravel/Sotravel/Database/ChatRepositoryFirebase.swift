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
            do {
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
                print("An error occurred", error)
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
        return updateChatBasicInfo(chatMessage: chatMessage, chatId: chatId)
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

    private func updateChatBasicInfo(chatMessage: ChatMessage, chatId: Int) -> Bool {
        let databasePath = databaseRef.child("chats/\(chatId)")
        let updateMessage = ["lastMessage": chatMessage.id.uuidString]
        databasePath.updateChildValues(updateMessage)
        return true
    }

    // MARK: FOR LISTENERS

    /*============================================================================================*/

    func setListenerForChatMessages(for chatId: UUID, completion: @escaping ((ChatMessage) -> Void)) {
        //        let databasePath = databaseRef.child("messages/\(chatId.uuidString)")
        //        databasePath.observe(.childAdded, with: { snapshot in
        //            guard let json = snapshot.value as? [String: Any] else {
        //                return
        //            }
        //            do {
        //                let chatMessageAMData = try JSONSerialization.data(withJSONObject: json)
        //                let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
        //                let chatMessage = ChatMessage(id: UUID(uuidString: chatMessageAM.id ?? "") ?? UUID(),
        //                                              messageText: chatMessageAM.messageText ?? "",
        //                                              timestamp: Date(timeIntervalSinceReferenceDate: chatMessageAM.timestamp),
        //                                              sender: UUID(uuidString: chatMessageAM.sender ?? "") ?? UUID())
        //                completion(chatMessage)
        //            } catch {
        //                print("An error occurred", error)
        //            }
        //        })
    }

    func removeListenerForChatMessages(for chatId: UUID) {
        //        let databasePath = databaseRef.child("messages/\(chatId.uuidString)")
        //        databasePath.removeAllObservers()
    }

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
                    let chat = self.convertApiModelsToChat(chatBasicInfoAM: chatBasicInfoAM, chatMessageAMs: [chatMessageAM])
                    completion(chat)
                })
            } catch {
                print("An error occurred", error)
            }
        })
    }
}

// MARK: CONVERTERS
extension ChatRepositoryFirebase {
    func convertApiModelsToChat(chatBasicInfoAM: ChatBasicInfoApiModel, chatMessageAMs: [ChatMessageApiModel] = []) -> Chat {
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

// MARK: FOR SAFEKEEPING
extension ChatRepositoryFirebase {
    //    func setListenerForAddedChat(userId: UUID, completion: @escaping ((Chat) -> Void)) {
    //        let databasePath = self.databaseRef.child("userChats/\(userId.uuidString)")
    //        databasePath.observe(.childAdded, with: { snapshot in
    //            guard let json = snapshot.value as? String, let chatId = UUID(uuidString: json) else {
    //                return
    //            }
    //
    //            self.getChatBasicInfoAM(chatId: chatId, completion: { chatBasicInfoAM in
    //                guard let lastMessage = chatBasicInfoAM.lastMessage,
    //                      let messageId = UUID(uuidString: lastMessage) else {
    //                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
    //                                    messages: [],
    //                                    title: chatBasicInfoAM.title ?? "",
    //                                    members: [])
    //                    completion(chat)
    //                    return
    //                }
    //
    //                self.getLastMessage(chatId: chatId, messageId: messageId, completion: { chatMessage in
    //                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
    //                                    messages: [chatMessage],
    //                                    title: chatBasicInfoAM.title ?? "",
    //                                    members: [])
    //                    completion(chat)
    //                })
    //            })
    //        })
    //    }
}
