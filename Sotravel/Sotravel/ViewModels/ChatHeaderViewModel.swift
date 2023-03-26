//
//  ChatHeaderViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatHeaderViewModel: ObservableObject {
    @Published var chatTitle: String?
    @Published var eventDatetime: Date?

    init(chatTitle: String = "", eventDatetime: Date? = nil) {
        self.chatTitle = chatTitle
        self.eventDatetime = eventDatetime
    }
}
