//
//  ContentView.swift
//  Sotravel
//
//  Created by Apple on 9/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapPageView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .id(UUID().uuidString)
            InvitePageView()
                .tabItem {
                    Image(systemName: "megaphone.fill")
                    Text("Invites")
                }
            CreateInvitePageView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
            ChatPageView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            ProfilePageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.font(.uiBody)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(mockUser)
            .environmentObject(EventsStore(events: mockEvents))
    }
}
