import SwiftUI

struct FriendsListPageView<ActionComponent: View>: View {
    @EnvironmentObject private var userService: UserService
    @State private var searchText = ""
    @Binding var hasNavigated: Bool
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

    init(friends: [User], actionComponent: @escaping (User) -> ActionComponent, hasNavigated: Binding<Bool> = .constant(false)) {
        self.friends = friends
        self.actionComponent = actionComponent
        self._hasNavigated = hasNavigated
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
        .onAppear {
            hasNavigated = true
        }
    }
}

struct FriendsListPageView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListPageView(friends: mockFriends, actionComponent: { _ in EmptyView() })
    }
}
