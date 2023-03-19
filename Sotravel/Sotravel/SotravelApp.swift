//
//  SotravelApp.swift
//  Sotravel
//
//  Created by Apple on 9/3/23.
//

import SwiftUI

@main
struct SotravelApp: App {
    @StateObject var events = EventsStore(events: mockEvents)
    @StateObject var userService = UserService()
    @StateObject var chats = ChatsStore(chats: mockChats)
    @StateObject var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(events)
                .environmentObject(userService)
                .environmentObject(chats)
                .environmentObject(chatViewModel)
        }
    }
}
