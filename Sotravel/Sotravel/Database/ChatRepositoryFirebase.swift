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

                    // TODO: get user from id
                    let chatMembers = chatMemberAMs.map {
                        User(id: UUID(uuidString: $0.id ?? "") ?? UUID())
                    }

                    guard let eventId = chatBasicInfoAM.event else { // we take it as no event
                        let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                        messages: chatMessages,
                                        title: chatBasicInfoAM.title ?? "Untitled",
                                        members: chatMembers)
                        completion(chat)
                        return
                    }

                    if eventId.isEmpty {
                        let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                        messages: chatMessages,
                                        title: chatBasicInfoAM.title ?? "Untitled",
                                        members: chatMembers)
                        completion(chat)
                    } else {
                        // TODO: get event from id
                        let event = Event(id: UUID(uuidString: eventId) ?? UUID(),
                                          activity: "temp",
                                          invitedUsers: [mockMe, mockNotMe],
                                          attendingUsers: [mockMe],
                                          rejectedUsers: [mockNotMe],
                                          datetime: Date.now,
                                          location: "",
                                          meetingPoint: "",
                                          description: "",
                                          hostUser: mockMe)
                        let chat = Chat(id: UUID(uuidString: chatBasicInfoAM.id ?? "") ?? UUID(),
                                        messages: chatMessages,
                                        members: chatMembers,
                                        event: event)
                        completion(chat)
                    }
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
        // TODO: actual implementation - convert to api model and send to db for storage
        return true
    }
}
