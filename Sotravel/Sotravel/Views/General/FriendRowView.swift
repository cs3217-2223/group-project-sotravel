import SwiftUI

struct FriendRowView: View {
    let friend: User
    @State private var showActionSheet = false

    var body: some View {
        HStack(spacing: 10) {
            ProfileImageView(imageSrc: friend.imageURL, name: friend.name, width: 60, height: 60)
                .padding(.trailing, 6)
            VStack(alignment: .leading, spacing: 6) {
                Text(friend.name)
                    .font(.uiHeadline)
                    .foregroundColor(.black)

                if let description = friend.description {
                    Text(description)
                        .font(.uiSubheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: {
                self.showActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Options"), buttons: [
                    .default(Text("View profile")),
                    .destructive(Text("Unfriend")),
                    .cancel()
                ])
            }
        }
    }
}
