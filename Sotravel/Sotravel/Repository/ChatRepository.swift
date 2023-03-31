//
//  ChatCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol ChatRepository {
    func getBasicInfoChats(userId: UUID, completion: @escaping ((Chat) -> Void))
    func getChat(chatId: UUID, completion: @escaping ((Chat) -> Void))
    func sendChatMessage(chatMessage: ChatMessage, chatId: UUID) -> Bool
    func setListenerForChatMessages(for chatId: UUID, completion: @escaping ((ChatMessage) -> Void))
    func removeListenerForChatMessages(for chatId: UUID)
    func setListenerForChatBasicInfo(for chatId: UUID, completion: @escaping ((Chat) -> Void))
    func setListenerForAddedChat(userId: UUID, completion: @escaping ((Chat) -> Void))
    func getChatIdFromEvent(eventId: Int, completion: @escaping ((UUID) -> Void))

    func getBasicInfo(for id: Int, completion: @escaping ((Chat) -> Void))
    func getChat(id: Int, completion: @escaping ((Chat) -> Void))
    func sendChatMessage(chatMessage: ChatMessage, to chatId: Int) -> Bool
}
