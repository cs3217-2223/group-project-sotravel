import SwiftUI

struct TripsPageView: View {
    let trips: [Trip] = mockTrips
    @EnvironmentObject var chatService: ChatService

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
                        .simultaneousGesture(TapGesture().onEnded {
                            self.chatService.fetchChatPageCells()
                        })
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
        NavigationView {
            TripsPageView()
                .environmentObject(UserService())
                .environmentObject(EventsStore(events: mockEvents))
        }
    }
}
