import SwiftUI

struct ActionMenuButton: View {
    let user: User

    @State private var showActionSheet = false

    var body: some View {
        Button(action: {
            self.showActionSheet = true
        }, label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.black)
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Options"), buttons: [
                .default(
                    Text("View Profile")
                ),
                .destructive(Text("Unfriend")),
                .cancel()
            ])
        }
    }
}
