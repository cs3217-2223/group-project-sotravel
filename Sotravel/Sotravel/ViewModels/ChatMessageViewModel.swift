//
//  ChatMessageViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatMessageViewModel: ObservableObject, Identifiable {
    @Published var messageText: String?
    @Published var messageTimestamp: Date // TODO: make it a string
    @Published var senderImageSrc: String?
    @Published var senderName: String?
    @Published var isSentByMe: Bool?

    // TODO: convert the date to string
    init(messageText: String = "", messageTimestamp: Date = Date.now, senderImageSrc: String = "",
         senderName: String = "", isSentByMe: Bool = false) {
        self.messageText = messageText
        self.messageTimestamp = messageTimestamp
        self.senderImageSrc = senderImageSrc
        self.senderName = senderName
        self.isSentByMe = isSentByMe
    }
}
