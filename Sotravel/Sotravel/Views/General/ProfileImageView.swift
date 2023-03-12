import SwiftUI

struct ProfileImageView: View {
    var imageSrc: String?
    var name: String
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        if let imageSrc = imageSrc, let url = URL(string: imageSrc) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: width, height: height)
            } placeholder: {
                ProgressView()
            }
        } else {
            let initials = name
                .split(separator: " ")
                .map { String($0.first ?? Character("")) }
                .joined()
                .prefix(2)
                .uppercased()
            Text(initials)
                .font(.system(size: 64))
                .foregroundColor(.gray)
                .frame(width: width, height: height)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}
