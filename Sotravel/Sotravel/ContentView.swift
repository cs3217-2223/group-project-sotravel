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
                    Image(systemName: "person.3.sequence.fill")
                    Text("Invites")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
