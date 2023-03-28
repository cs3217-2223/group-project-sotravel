//
//  ChatMessageApiModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 27/3/23.
//

import Foundation

struct ChatMessageApiModel: Codable {
    let id: String?
    let messageText: String?
    let sender: String?
    let timestamp: Double
}
