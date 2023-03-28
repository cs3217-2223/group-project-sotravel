//
//  ChatMessageViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatMessageViewModel: ObservableObject, Identifiable {
    @Published var messageText: String?
    @Published var messageTimestamp: Date // make string + separate for timestamp above msg?
    @Published var senderImageSrc: String?
    @Published var senderName: String?
    @Published var isSentByMe: Bool?
    var id: UUID

    // convert the date to string?
    init(messageText: String = "", messageTimestamp: Date = Date.now, senderImageSrc: String = "",
         senderName: String = "", isSentByMe: Bool = false, id: UUID = UUID()) {
        self.messageText = messageText
        self.messageTimestamp = messageTimestamp
        self.senderImageSrc = senderImageSrc
        self.senderName = senderName
        self.isSentByMe = isSentByMe
        self.id = id
    }
}
