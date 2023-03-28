import SwiftUI

struct UserAnnotationView: View {
    var user: User

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            ProfileImageView(imageSrc: user.imageURL, name: user.name ?? "", width: 36, height: 36)
        }
    }
}
