import SwiftUI

struct ProfileFriendsView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var friendService: FriendService
    @EnvironmentObject private var tripService: TripService
    @ObservedObject var viewModel: ProfileFriendsViewModel

    @State private var refreshing = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Friends")
                    .font(.uiTitle3)
                Spacer()
                if refreshing {
                    ProgressView()
                } else {
                    Button(action: {
                        refreshing = true
                        self.refresh()
                    }, label: {
                        Text("Refresh")
                            .padding()
                            .cornerRadius(10)
                    })
                }

            }.padding(.bottom, 10)
            VStack(spacing: 0) {
                let usersShown = viewModel.friends.prefix(3)
                ForEach(Array(usersShown.enumerated()), id: \.element.id) { index, friend in
                    NavigationLink(destination: FriendProfilePageView(friend: friend)) {
                        UserListItemView(user: friend) {
                            ActionMenuButton()
                        }
                    }
                    if index != usersShown.count - 1 {
                        Divider()
                            .padding(.top, 10)
                            .padding(.bottom, 9)
                    }
                }
            }.padding(.trailing)
            if viewModel.friends.count > 3 {
                NavigationLink(destination: FriendsListPageView(friends: viewModel.friends)) {
                    HStack {
                        Spacer()
                        Text("See All Friends")
                            .font(.uiHeadline)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(.top, 6)
    }

    private func refresh() {
        guard let tripId = tripService.getCurrTripId() else {
            return
        }
        friendService.reloadFriends(tripId: tripId) { success in
            if success {
                refreshing = false
            } else {
                refreshing = false
            }
        }
    }
}

struct ProfileFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFriendsView(viewModel: ProfileFriendsViewModel())
            .environmentObject(UserService())
            .environmentObject(EventsStore(events: mockEvents))
    }
}
