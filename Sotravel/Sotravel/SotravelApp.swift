//
//  SotravelApp.swift
//  Sotravel
//
//  Created by Apple on 9/3/23.
//

import SwiftUI

@main
struct SotravelApp: App {
    @StateObject var eventService = EventService()
    @StateObject var userService = UserService()
    @StateObject var chats = ChatsStore(chats: mockChats)
    @StateObject var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(eventService)
                .environmentObject(userService)
                .environmentObject(chats)
                .environmentObject(chatViewModel)
        }
    }
}
