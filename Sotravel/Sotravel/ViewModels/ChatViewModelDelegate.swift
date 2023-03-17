//
//  ChatViewModelDelegate.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 17/3/23.
//

import Foundation

protocol ChatViewModelDelegate: AnyObject {
    func sendChatMessage(messageText: String, sender: User, toChat: Chat) -> Bool
    // Possible additions: edit, delete
}
