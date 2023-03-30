//
//  ChatHeaderViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatHeaderViewModel: ObservableObject {
    @Published var chatTitle: String?
    @Published var eventId: Int?

    init(chatTitle: String = "", eventId: Int? = nil) {
        self.chatTitle = chatTitle
        self.eventId = eventId
    }
}
