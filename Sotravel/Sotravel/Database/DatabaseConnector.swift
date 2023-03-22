//
//  DatabaseConnector.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 19/3/23.
//

import Foundation

protocol DatabaseConnector {
    func sendChatMessage(chatMessage: ChatMessage, chat: Chat) -> Bool
}
