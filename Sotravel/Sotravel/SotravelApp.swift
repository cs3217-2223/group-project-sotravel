//
//  SotravelApp.swift
//  Sotravel
//
//  Created by Apple on 9/3/23.
//

import SwiftUI

@main
struct SotravelApp: App {
    @StateObject var user = mockUser
    @StateObject var events = EventsStore(events: mockEvents)
    @StateObject var chats = ChatsStore(chats: mockChats)
    @StateObject var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(events)
                .environmentObject(chats)
                .environmentObject(chatViewModel)
        }
    }
}
