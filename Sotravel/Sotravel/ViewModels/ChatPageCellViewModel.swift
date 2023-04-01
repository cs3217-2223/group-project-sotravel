//
//  ChatPageCellViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatPageCellViewModel: ObservableObject, Identifiable {
    @Published var lastMessageText: String?
    @Published var lastMessageSender: String? // id, keep as string
    @Published var lastMessageTimestamp: String?
    @Published var id: Int?

    init(lastMessageText: String? = nil, lastMessageSender: String? = nil,
         lastMessageDate: Date? = nil, id: Int? = nil) {
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

    func update(with newVM: ChatPageCellViewModel) {
        self.lastMessageText = newVM.lastMessageText
        self.lastMessageSender = newVM.lastMessageSender
        self.lastMessageTimestamp = newVM.lastMessageTimestamp
        self.id = newVM.id
    }
}
