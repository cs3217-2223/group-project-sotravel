import SwiftUI

struct UserHorizontalListView: View {
    @EnvironmentObject private var friendService: FriendService
    let users: [UUID]
    @State var userIdToUser: [UUID: User] = [:]

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
                        if let user = userIdToUser[userId] {
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
                    await self.getUser(id: userId)
                }
            }
        }
    }
    
    private func getUser(id: UUID) async {
        do {
            var user = try await friendService.getFriend(id: id)
            userIdToUser[id] = user
        } catch {
            print(error)
        }
    }
}
