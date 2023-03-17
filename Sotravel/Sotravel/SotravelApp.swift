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
    @StateObject var userDataManager = UserDataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(events)
                .environmentObject(userDataManager)
        }
    }
}
