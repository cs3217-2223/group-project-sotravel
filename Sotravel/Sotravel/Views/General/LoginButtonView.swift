import SwiftUI

struct LoginButtonView: View {
    var action: () -> Void
    var title: String
    var imageName: String?
    var url: String?

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.white)
                }
                if let url = url {
                    Link(title,
                         destination: URL(string: url)!)
                        .foregroundColor(.white).font(.uiButton)
                } else {
                    Text(title)
                        .foregroundColor(.white).font(.uiButton)
                }
            }
            .font(.uiBody.weight(.medium))
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .clipped()
            .foregroundColor(Color(.systemBackground))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.uiPrimary)
            }
        }
    }
}

struct LoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtonView(action: {
            print("Button tapped")
        }, title: "Continue with Telegram", imageName: "paperplane.fill", url: "https://sotravel.me/app-login")
    }
}
