import SwiftUI

struct UserHorizontalListView: View {
    let users: [User]

    var body: some View {
        if users.isEmpty {
            HStack {
                Text("No one's here 👀").font(.uiCallout)
                Spacer()
            }.padding(.leading, 4)
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 2) {
                    ForEach(users, id: \.self) { user in
                        NavigationLink(destination: FriendProfilePageView(friend: user)) {
                            ProfileImageView(
                                imageSrc: user.imageURL,
                                name: user.name ?? "John Doe",
                                width: 50,
                                height: 50
                            )
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}
