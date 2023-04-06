import SwiftUI

func DismissKeyboardToolbarView() -> some View {
    HStack {
        Spacer()
        Button(action: {
            hideKeyboard()
        }) {
            Text("Done")
                .bold()
        }
    }
    .padding(.horizontal)
    .background(Color(.systemGroupedBackground))
}
