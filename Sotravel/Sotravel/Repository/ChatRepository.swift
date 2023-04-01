//
//  ChatCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol ChatRepository {
    func setListenerForChatMessages(for chatId: Int, completion: @escaping ((ChatMessage) -> Void))
    func removeListenerForChatMessages(for chatId: Int)
    func setListenerForChatBasicInfo(for chatId: Int, completion: @escaping ((Chat) -> Void))
    func removeListenerForChatBasicInfo(for chatId: Int)
    func getBasicInfo(for id: Int, completion: @escaping ((Chat) -> Void))
    func getChat(id: Int, completion: @escaping ((Chat) -> Void))
    func sendChatMessage(chatMessage: ChatMessage, to chatId: Int) -> Bool
}
