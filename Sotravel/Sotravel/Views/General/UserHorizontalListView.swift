import SwiftUI

struct UserHorizontalListView: View {
    @EnvironmentObject private var userService: UserService
    let users: [UUID]

    var body: some View {
        if users.isEmpty {
            HStack {
                Text("No one's here 👀").font(.uiCallout)
                Spacer()
            }.padding(.leading, 4)
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 2) {
                    ForEach(users, id: \.self) { userId in
                        if let user = userService.userCache[userId] {
                            NavigationLink(destination: FriendProfilePageView(friend: user)) {
                                ProfileImageView(
                                    imageSrc: user.imageURL,
                                    name: user.name ?? "John Doe",
                                    width: 50,
                                    height: 50
                                )
                            }
                        }
                    }
                    Spacer()
                }
            }
            .task {
                for userId in users {
                    await userService.fetchUserIfNeededFrom(id: userId)
                }
            }
        }
    }
}
