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
}
