import SwiftUI

struct FriendsListPageView<ActionComponent: View>: View {
    @EnvironmentObject private var userService: UserService
    @State private var searchText = ""
    var friends: [User]
    var filteredFriends: [User] {
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

    var actionComponent: (User) -> ActionComponent

    init(friends: [User], @ViewBuilder actionComponent: @escaping (User) -> ActionComponent) {
        self.friends = friends
        self.actionComponent = actionComponent
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            ScrollView {
                ForEach(filteredFriends, id: \.id) { friend in
                    actionComponent(friend)
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
        FriendsListPageView(friends: mockFriends, actionComponent: { _ in EmptyView() })
    }
}
