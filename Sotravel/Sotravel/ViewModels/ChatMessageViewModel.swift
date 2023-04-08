//
//  ChatMessageViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatMessageViewModel: ObservableObject, Identifiable {
    @Published var messageText: String?
    @Published var messageTimestamp: Date
    @Published var senderId: UUID
    @Published var isSentByMe: Bool?
    var id: UUID

    init(messageText: String = "", messageTimestamp: Date = Date.now,
         senderId: UUID = UUID(), isSentByMe: Bool = false, id: UUID = UUID()) {
        self.messageText = messageText
        self.messageTimestamp = messageTimestamp
        self.senderId = senderId
        self.isSentByMe = isSentByMe
        self.id = id
    }
}
