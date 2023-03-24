import SwiftUI

struct TripCardView: View {
    let trip: Trip

    var body: some View {
        VStack {
            URLImageView(src: trip.imageURL)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(trip.title)
                        .font(.uiHeadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")

                    Text("\(trip.startDate.toFriendlyDateString()) - \(trip.endDate.toFriendlyDateString())")
                        .font(.uiSubheadline)
                }

                HStack {
                    Image(systemName: "location.fill")

                    Text(trip.location)
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
