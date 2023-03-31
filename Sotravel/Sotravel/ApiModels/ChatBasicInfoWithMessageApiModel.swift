//
//  ChatBasicInfoWithMessageApiModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 28/3/23.
//

import Foundation

struct ChatBasicInfoWithMessageApiModel: Codable {
    let id: String?
    let lastMessage: ChatMessageApiModel?
}
