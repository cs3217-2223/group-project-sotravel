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

    func getChat(chatId: UUID, completion: @escaping ((Chat) -> Void)) {
        getChatBasicInfoAM(chatId: chatId, completion: { chatBasicInfoAM in
            self.getChatMessages(chatId: chatId, completion: { chatMessageAMs in
                self.getChatMembers(chatId: chatId, completion: { chatMemberAMs in
                    let chatMessages = chatMessageAMs.map {
                        ChatMessage(id: UUID(uuidString: $0.id ?? "") ?? UUID(),
                                    messageText: $0.messageText ?? "",
                                    timestamp: Date(timeIntervalSinceReferenceDate: $0.timestamp),
                                    sender: UUID(uuidString: $0.sender ?? "") ?? UUID())
                    }

                    let chatMembers = chatMemberAMs.map {
                        User(id: UUID(uuidString: $0.id ?? "") ?? UUID())
                    }

                    guard let eventId = chatBasicInfoAM.event, eventId >= 0 else { // we take it as no event
                        let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                        messages: chatMessages,
                                        title: chatBasicInfoAM.title ?? "Untitled",
                                        members: chatMembers)
                        completion(chat)
                        return
                    }

                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                    messages: chatMessages,
                                    title: chatBasicInfoAM.title ?? "Untitled",
                                    members: chatMembers,
                                    eventId: eventId)
                    completion(chat)
                })
            })
        })
    }

    private func getChatBasicInfoAM(chatId: UUID, completion: @escaping ((ChatBasicInfoApiModel) -> Void)) {
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
    }

    private func getChatMessages(chatId: UUID, completion: @escaping (([ChatMessageApiModel]) -> Void)) {
        let databasePath = self.databaseRef.child("messages/\(chatId)")
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

    private func getChatMembers(chatId: UUID, completion: @escaping (([ChatMemberApiModel]) -> Void)) {
        let databasePath = self.databaseRef.child("chatMembers/\(chatId)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsons = snapshot?.value as? [String: String] else {
                return
            }
            var chatMemberAMs = [ChatMemberApiModel]()
            for json in jsons {
                let data = json.value
                let chatMemberAM = ChatMemberApiModel(id: data)
                chatMemberAMs.append(chatMemberAM)
            }
            completion(chatMemberAMs)
        })
    }

    func sendChatMessage(chatMessage: ChatMessage, chatId: UUID) -> Bool {
        if !addChatMessage(chatMessage: chatMessage, chatId: chatId) {
            return false
        }

        return updateChatBasicInfo(chatMessage: chatMessage, chatId: chatId)
    }

    private func addChatMessage(chatMessage: ChatMessage, chatId: UUID) -> Bool {
        let databasePath = databaseRef.child("messages/\(chatId.uuidString)")
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

    private func updateChatBasicInfo(chatMessage: ChatMessage, chatId: UUID) -> Bool {
        let databasePath = databaseRef.child("chats/\(chatId.uuidString)")
        let updateMessage = ["lastMessage": chatMessage.id.uuidString]
        databasePath.updateChildValues(updateMessage)
        return true
    }

    func setListenerForChatMessages(for chatId: UUID, completion: @escaping ((ChatMessage) -> Void)) {
        let databasePath = databaseRef.child("messages/\(chatId.uuidString)")
        databasePath.observe(.childAdded, with: { snapshot in
            guard let json = snapshot.value as? [String: Any] else {
                return
            }
            do {
                let chatMessageAMData = try JSONSerialization.data(withJSONObject: json)
                let chatMessageAM = try self.decoder.decode(ChatMessageApiModel.self, from: chatMessageAMData)
                let chatMessage = ChatMessage(id: UUID(uuidString: chatMessageAM.id ?? "") ?? UUID(),
                                              messageText: chatMessageAM.messageText ?? "",
                                              timestamp: Date(timeIntervalSinceReferenceDate: chatMessageAM.timestamp),
                                              sender: UUID(uuidString: chatMessageAM.sender ?? "") ?? UUID())
                completion(chatMessage)
            } catch {
                print("An error occurred", error)
            }
        })
    }

    func removeListenerForChatMessages(for chatId: UUID) {
        let databasePath = databaseRef.child("messages/\(chatId.uuidString)")
        databasePath.removeAllObservers()
    }

    func setListenerForChatBasicInfo(for chatId: UUID, completion: @escaping ((Chat) -> Void)) {
        let databasePath = databaseRef.child("chats/\(chatId.uuidString)")
        databasePath.observe(.value, with: { snapshot in
            guard let json = snapshot.value as? [String: Any] else {
                return
            }
            do {
                let chatBasicInfoAMData = try JSONSerialization.data(withJSONObject: json)
                let chatBasicInfoAM = try self.decoder.decode(ChatBasicInfoApiModel.self, from: chatBasicInfoAMData)
                guard let lastMessage = chatBasicInfoAM.lastMessage, let messageId = UUID(uuidString: lastMessage) else {
                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                    messages: [],
                                    title: chatBasicInfoAM.title ?? "",
                                    members: [])
                    completion(chat)
                    return
                }

                self.getLastMessage(chatId: chatId, messageId: messageId, completion: { chatMessage in
                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                    messages: [chatMessage],
                                    title: chatBasicInfoAM.title ?? "",
                                    members: [])
                    completion(chat)
                })
            } catch {
                print("An error occurred", error)
            }
        })
    }

    private func getLastMessage(chatId: UUID, messageId: UUID, completion: @escaping ((ChatMessage) -> Void)) {
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
                let chatMessage = ChatMessage(id: UUID(uuidString: chatMessageAM.id ?? "") ?? UUID(),
                                              messageText: chatMessageAM.messageText ?? "",
                                              timestamp: Date(timeIntervalSinceReferenceDate: chatMessageAM.timestamp),
                                              sender: UUID(uuidString: chatMessageAM.sender ?? "") ?? UUID())
                completion(chatMessage)
            } catch {
                print("An error occurred", error)
            }
        })
    }

    func setListenerForAddedChat(userId: UUID, completion: @escaping ((Chat) -> Void)) {
        let databasePath = self.databaseRef.child("userChats/\(userId.uuidString)")
        databasePath.observe(.childAdded, with: { snapshot in
            guard let json = snapshot.value as? String, let chatId = UUID(uuidString: json) else {
                return
            }

            self.getChatBasicInfoAM(chatId: chatId, completion: { chatBasicInfoAM in
                guard let lastMessage = chatBasicInfoAM.lastMessage,
                      let messageId = UUID(uuidString: lastMessage) else {
                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                    messages: [],
                                    title: chatBasicInfoAM.title ?? "",
                                    members: [])
                    completion(chat)
                    return
                }

                self.getLastMessage(chatId: chatId, messageId: messageId, completion: { chatMessage in
                    let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                    messages: [chatMessage],
                                    title: chatBasicInfoAM.title ?? "",
                                    members: [])
                    completion(chat)
                })
            })
        })
    }

    func getChatIdFromEvent(eventId: Int, completion: @escaping ((UUID) -> Void)) {
        let databasePath = self.databaseRef.child("eventChat/\(eventId)")
        databasePath.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let json = snapshot?.value as? String, let chatId = UUID(uuidString: json) else {
                return
            }
            completion(chatId)
        })
    }
}
