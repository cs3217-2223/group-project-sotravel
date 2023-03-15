import SwiftUI

struct TripsPageView: View {
    let trips: [Trip] = mockTrips

    var body: some View {
        ScrollView {
            HStack {
                Text("My Trips")
                    .font(.uiTitle1)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 16) {
                ForEach(trips) { trip in
                    NavigationLink(destination: TripPageView()) {
                        TripCardView(trip: trip)
                    }.foregroundColor(.primary)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)

    }
}

struct TripsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TripsPageView()
                .environmentObject(mockUser)
                .environmentObject(EventsStore(events: mockEvents))
        }
    }
}
