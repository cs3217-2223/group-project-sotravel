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
    @Published var eventId: Int?
    var id: UUID

    init(chatTitle: String = "", lastMessageText: String? = nil, lastMessageSender: String? = nil,
         lastMessageDate: Date? = nil, id: UUID = UUID(), eventId: Int? = nil) {
        self.chatTitle = chatTitle
        self.lastMessageText = lastMessageText
        self.lastMessageSender = lastMessageSender
        self.id = id
        self.eventId = eventId

        guard let timeStamp = lastMessageDate else {
            self.lastMessageTimestamp = ""
            return
        }
        let calendar = Calendar(identifier: .iso8601)
        self.lastMessageTimestamp = timeStamp.isToday(using: calendar)
            ? timeStamp.toFriendlyTimeString()
            : timeStamp.toFriendlyDateString()
    }

    func update(with newVM: ChatPageCellViewModel) {
        self.chatTitle = newVM.chatTitle
        self.lastMessageText = newVM.lastMessageText
        self.lastMessageSender = newVM.lastMessageSender
        self.lastMessageTimestamp = newVM.lastMessageTimestamp
        self.eventId = newVM.eventId
    }
}
