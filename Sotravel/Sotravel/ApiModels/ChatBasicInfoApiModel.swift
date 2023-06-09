//
//  ChatBasicInfoApiModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 27/3/23.
//

import Foundation

struct ChatBasicInfoApiModel: Codable {
    let id: String?
    let lastMessage: String?
    let secondLastMessage: String?
    let thirdLastMessage: String?
}
