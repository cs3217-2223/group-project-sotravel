//
//  ChatsStore.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 18/3/23.
//
import Foundation

class ChatsStore: ObservableObject {
    @Published var chats: [Chat]

    init(chats: [Chat]) {
        self.chats = chats
    }

    func findChats(for user: User) -> [Chat] {
        chats.filter { $0.isUserInChat(user: user) }
    }
}
