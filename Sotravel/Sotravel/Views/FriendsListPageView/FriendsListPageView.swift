import SwiftUI

struct FriendsListPageView: View {
    @State private var searchText = ""

    var friends: [User]
    var filteredFriends: [User] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            ScrollView {
                ForEach(filteredFriends, id: \.id) { friend in
                    NavigationLink(destination: FriendProfilePageView(friend: friend)) {
                        UserListItemView(user: friend) {
                            ActionMenuButton(user: friend)
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
        FriendsListPageView(friends: mockFriends)
    }
}
