//
//  SotravelApp.swift
//  Sotravel
//
//  Created by Apple on 9/3/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct SotravelApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var user = mockUser
    @StateObject var events = EventsStore(events: mockEvents)
    @StateObject var userService = UserService()
    @StateObject var chats = ChatsStore(chats: mockChats)
    @StateObject var chatViewModel = ChatViewModel(user: mockUser, databaseConnector: DatabaseAdapter()) // db should be 1 obj that is passed around?

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
