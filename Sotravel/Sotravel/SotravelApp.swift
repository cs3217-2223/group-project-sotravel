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
    @StateObject var chats = ChatsStore(chats: mockChats)
    @StateObject var chatViewModel = ChatViewModel(user: mockUser)

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
