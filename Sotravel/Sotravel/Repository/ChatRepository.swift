//
//  ChatCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol ChatRepository {
    func getBasicInfoChats(userId: UUID) -> [Chat]
    func getChat(chatId: UUID) -> Chat
    func sendChatMessage(chatMessage: ChatMessage, chatId: UUID) -> Bool
}
