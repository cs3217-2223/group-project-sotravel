import SwiftUI

struct ActionMenuButton: View {

    @State private var showActionSheet = false

    var body: some View {
        Button(action: {
            self.showActionSheet = true
        }, label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.primary)
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Options"), buttons: [
                //                .destructive(Text("Unfriend")),
                .cancel()
            ])
        }
    }
}
