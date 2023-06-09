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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct SotravelApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var eventService = EventService()
    @StateObject var userService = UserService()
    @StateObject var tripService = TripService()
    @StateObject var friendService = FriendService()
    @StateObject var chats = ChatsStore(chats: mockChats)
    // db should be 1 obj that is passed around?
    @StateObject var chatService = ChatService()
    @StateObject var locationSharingState = LocationSharingViewModel()
    @StateObject var viewAlertController = ViewAlertController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(eventService)
                .environmentObject(userService)
                .environmentObject(tripService)
                .environmentObject(chatService)
                .environmentObject(friendService)
                .environmentObject(locationSharingState)
                .environmentObject(viewAlertController)
        }
    }
}
