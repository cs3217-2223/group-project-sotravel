import SwiftUI

struct UserHorizontalListView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var friendService: FriendService
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
                        if let user = self.getUser(id: userId) {
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
        }
    }

    private func getUser(id: UUID) -> User? {
        if let friend = friendService.getFriend(id: id) {
            return friend
        } else if let userId = userService.getUserId(), userId == id {
            return userService.getUser()
        } else {
            return nil
        }
    }
}
