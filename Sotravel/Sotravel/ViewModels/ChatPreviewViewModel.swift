//
//  ChatPreviewViewModel.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 8/4/23.
//

import Foundation

class ChatPreviewViewModel: ObservableObject, Identifiable {
    @Published var lastMessageVMs: [ChatMessageViewModel]
    @Published var id: Int?

    init(lastMessageVMs: [ChatMessageViewModel] = [], id: Int? = nil) {
        self.lastMessageVMs = lastMessageVMs
        self.id = id
    }
}
