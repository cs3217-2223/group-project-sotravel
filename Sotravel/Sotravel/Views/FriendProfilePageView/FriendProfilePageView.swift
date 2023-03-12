import SwiftUI

struct FriendProfilePageView: View {
    let friend: User

    var body: some View {
        VStack {
            // Profile picture and name
            // Bio and social media links
            // List of the friend's recent posts
        }
        .navigationBarTitle(Text(friend.name))
    }
}

