import SwiftUI

struct ProfileFriendsView: View {
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Friends")
                    .font(.uiTitle3)
                Spacer()
            }.padding(.bottom, 10)

            VStack(spacing: 0) {
                let usersShown = user.friends.prefix(3)
                ForEach(Array(usersShown.enumerated()), id: \.element.id) { index, friend in
                    NavigationLink(destination: FriendProfilePageView(friend: friend)) {
                        UserListItemView(user: friend) {
                            ActionMenuButton(user: user)
                        }
                    }

                    if index != usersShown.count - 1 {
                        Divider()
                            .padding(.top, 10)
                            .padding(.bottom, 9)
                    }
                }
            }.padding(.trailing)

            if user.friends.count > 3 {
                NavigationLink(destination: FriendsListPageView(friends: user.friends)) {
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
        ProfileFriendsView()
            .environmentObject(mockUser)
            .environmentObject(EventsStore(events: mockEvents))
    }
}
