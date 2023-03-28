import SwiftUI

struct FriendsListPageView: View {
    @EnvironmentObject private var userService: UserService
    @State private var searchText = ""

    var friends: [Friend]
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter {
                guard let name = $0.name else {
                    return false
                }
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            ScrollView {
                ForEach(filteredFriends, id: \.id) { friend in
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
                    Divider()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 20)

        }
        .navigationTitle("Friends")
    }
}

struct FriendsListPageView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListPageView(friends: mockFriendss)
    }
}
