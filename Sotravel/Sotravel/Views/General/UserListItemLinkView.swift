import SwiftUI

struct UserListItemLinkView: View {
    let friend: User

    var body: some View {
        NavigationLink(destination: FriendProfilePageView(friend: friend)) {
            HStack {
                UserListItemView(user: friend)
            }
        }
        Divider()
    }
}

struct UserListItemLinkView_Previews: PreviewProvider {
    static var previews: some View {
        UserListItemLinkView(friend: mockUser)
    }
}
