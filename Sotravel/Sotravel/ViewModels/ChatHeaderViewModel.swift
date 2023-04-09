//
//  ChatHeaderViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation

class ChatHeaderViewModel: ObservableObject {
    @Published var eventId: Int?

    init(eventId: Int? = nil) {
        self.eventId = eventId
    }
}
