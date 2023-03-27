import SwiftUI

struct ProfileFriendsView: View {
    @EnvironmentObject private var userService: UserService
    @ObservedObject var viewModel: ProfileFriendsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Friends")
                    .font(.uiTitle3)
                Spacer()
            }.padding(.bottom, 10)
            VStack(spacing: 0) {
                let usersShown = viewModel.friends.prefix(3)
                ForEach(Array(usersShown.enumerated()), id: \.element.id) { index, friend in
                    let user = userService.getUser(for: friend)
                    NavigationLink(destination: FriendProfilePageView(friend: user)) {
                        UserListItemView(user: user) {
                            ActionMenuButton()
                        }
                    }
                    .onAppear {
                        Task {
                            await userService.fetchUserIfNeeded(for: friend)
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
}

struct ProfileFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFriendsView(viewModel: ProfileFriendsViewModel())
            .environmentObject(UserService())
            .environmentObject(EventsStore(events: mockEvents))
    }
}
