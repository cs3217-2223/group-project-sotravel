import SwiftUI

struct UserListItemView<Content: View>: View {
    let user: User
    let content: (() -> Content)?

    @State private var showActionSheet = false

    var body: some View {
        HStack(spacing: 10) {
            ProfileImageView(imageSrc: user.imageURL, name: user.name, width: 60, height: 60)
                .padding(.trailing, 6)
            VStack(alignment: .leading, spacing: 6) {
                Text(user.name)
                    .font(.uiHeadline)
                    .foregroundColor(.black)

                if let description = user.description {
                    Text(description)
                        .font(.uiSubheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()

            if let content = content {
                content()
            }
        }
    }
}
