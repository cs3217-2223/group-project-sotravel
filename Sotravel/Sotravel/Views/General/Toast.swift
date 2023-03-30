import SwiftUI

struct Toast: View {
    var message: String
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .font(.uiHeadline)
            .cornerRadius(8)
    }
}
