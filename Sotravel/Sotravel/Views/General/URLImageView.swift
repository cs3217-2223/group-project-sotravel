import SwiftUI

struct URLImageView: View {
    var src: URL

    var body: some View {
        AsyncImage(url: src, transaction: Transaction(animation: .easeInOut(duration: 0.25))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            case .failure, .empty:
                ProgressView()
                    .frame(height: 180)
                    .clipped()
            default:
                ProgressView()
                    .frame(height: 180)
            }
        }
    }
}
