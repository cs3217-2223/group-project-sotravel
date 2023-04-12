import SwiftUI

struct TripCardView: View {
    var viewModel: TripViewModel

    var body: some View {
        VStack {
            URLImageView(src: viewModel.imageURL ?? URL(string: "about:blank")!)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(viewModel.title)
                        .font(.uiHeadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")

                    Text("\(viewModel.startDate.toFriendlyDateString()) - \(viewModel.endDate.toFriendlyDateString())")
                        .font(.uiSubheadline)
                }

                HStack {
                    Image(systemName: "location.fill")

                    Text(viewModel.location)
                        .font(.uiSubheadline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .cornerRadius(8)
            .padding(.bottom, 8)
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                .shadow(color: Color.primary.opacity(0.2), radius: 4, x: 0, y: 4)
        )
    }
}
