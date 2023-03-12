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
            InvitePageView()
                .tabItem {
                    Image(systemName: "megaphone.fill")
                    Text("Invites")
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
        }.font(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(mockUser)
            .environmentObject(EventsStore(events: mockEvents))
    }
}
