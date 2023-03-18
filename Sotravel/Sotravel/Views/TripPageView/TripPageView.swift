import SwiftUI

struct TripPageView: View {
    @State private var selectedTab: Int = 0
    @State private var mapPageViewID = UUID().uuidString
    @State private var invitePageViewID = UUID().uuidString
    @State private var createInvitePageViewID = UUID().uuidString
    @State private var chatPageViewID = UUID().uuidString
    @State private var profilePageViewID = UUID().uuidString

    var body: some View {
        TabView(selection: $selectedTab) {
            MapPageView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .id(mapPageViewID)
                .tag(0)

            InvitePageView()
                .tabItem {
                    Image(systemName: "megaphone.fill")
                    Text("Invites")
                }
                .id(invitePageViewID)
                .tag(1)

            CreateInvitePageView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
                .id(createInvitePageViewID)
                .tag(2)

            ChatPageView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
                .id(chatPageViewID)
                .tag(3)

            ProfilePageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .id(profilePageViewID)
                .tag(4)
        }
        .font(.uiBody)
        .onChange(of: selectedTab, perform: { _ in
            resetNavigationStacks()
        })
        .navigationBarBackButtonHidden(true)
    }

    private func resetNavigationStacks() {
        mapPageViewID = UUID().uuidString
        invitePageViewID = UUID().uuidString
        createInvitePageViewID = UUID().uuidString
        chatPageViewID = UUID().uuidString
        profilePageViewID = UUID().uuidString
    }
}

struct TripPageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserDataManager())
            .environmentObject(EventsStore(events: mockEvents))
    }
}
