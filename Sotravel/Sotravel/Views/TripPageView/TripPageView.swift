import SwiftUI

struct TripPageView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var friendService: FriendService
    @EnvironmentObject private var tripService: TripService
    @EnvironmentObject private var chatService: ChatService
    @Binding var selectedTab: Int
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
            if let vm = friendService.getCreateInvitePageViewModel() {
                CreateInvitePageView(createInvitePageViewModel: vm)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Create")
                    }
                    .id(createInvitePageViewID)
                    .tag(2)
            }

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
        .onChange(of: selectedTab, perform: tabTapped)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.resetNavigationStacks()
        }
    }

    private func tabTapped(_ selectedTab: Int) {
        resetNavigationStacks()

        // Add any additional actions you want to perform when a tab is tapped
        if selectedTab == 1 {
            if let tripId = tripService.getCurrTripId(), let userId = userService.currentUserId {
                eventService.reloadUserEvents(forTrip: tripId, userId: userId)
            }
        } else if selectedTab == 3 {
            if let user = userService.getCurrentUser() {
                let eventIds = eventService.findAttendingEventsId(for: user)
                chatService.fetchChatPageCells(ids: eventIds)
            }
        } else if selectedTab == 4 {

        }
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
            .environmentObject(UserService())
            .environmentObject(EventsStore(events: mockEvents))
    }
}
