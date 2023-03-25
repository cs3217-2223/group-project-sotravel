//
//  ChatPageCellViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatPageCellViewModel: ObservableObject, Identifiable {
    @Published var chatTitle: String?
    @Published var lastMessageText: String?
    @Published var lastMessageSender: String?
    @Published var lastMessageTimestamp: String?
    var id: UUID

    init(chatTitle: String = "", lastMessageText: String = "", lastMessageSender: String = "", lastMessageDate: Date? = nil, id: UUID = UUID()) {
        self.chatTitle = chatTitle
        self.lastMessageText = lastMessageText
        self.lastMessageSender = lastMessageSender
        self.id = id

        guard let timeStamp = lastMessageDate else {
            self.lastMessageTimestamp = ""
            return
        }
        let calendar = Calendar(identifier: .iso8601)
        self.lastMessageTimestamp = timeStamp.isToday(using: calendar)
            ? timeStamp.toFriendlyTimeString()
            : timeStamp.toFriendlyDateString()
    }
}
