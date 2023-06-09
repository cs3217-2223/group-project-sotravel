import SwiftUI

struct UserListItemView<Content: View>: View {
    let user: User?
    let content: (() -> Content)?

    @State private var showActionSheet = false

    init(user: User?, content: (() -> Content)? = { EmptyView() }) {
        self.user = user
        self.content = content
    }

    var body: some View {
        HStack(spacing: 10) {
            ProfileImageView(imageSrc: user?.imageURL, name: user?.name ?? "", width: 60, height: 60)
                .padding(.trailing, 6)
            VStack(alignment: .leading, spacing: 6) {
                Text(user?.name ?? "")
                    .font(.uiHeadline)
                    .foregroundColor(.primary)

                if let description = user?.desc {
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
