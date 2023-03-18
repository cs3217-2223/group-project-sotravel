import SwiftUI

struct TripsPageView: View {
    let trips: [Trip] = mockTrips

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("My Trips")
                        .font(.uiTitle1)
                    Spacer()
                }
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(trips) { trip in
                        NavigationLink(destination: TripPageView()) {
                            TripCardView(trip: trip)
                        }.foregroundColor(.primary)
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TripsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TripsPageView()
                .environmentObject(UserDataManager())
                .environmentObject(EventsStore(events: mockEvents))
        }
    }
}
