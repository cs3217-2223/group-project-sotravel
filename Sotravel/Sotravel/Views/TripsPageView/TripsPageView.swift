import SwiftUI

struct TripsPageView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var eventService: EventService
    @EnvironmentObject var tripService: TripService
    @EnvironmentObject var friendService: FriendService

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("My Trips")
                        .font(.uiTitle1)
                    Spacer()
                }
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(tripService.getTrips()), id: \.id) { trip in
                        NavigationLink(destination: TripPageView(selectedTab: $tripService.selectedTapInCurrTrip)) {
                            TripCardView(trip: trip)
                        }.foregroundColor(.primary)
                        .simultaneousGesture(TapGesture().onEnded {
                            // Call loadUserData when the TripCardView is tapped
                            self.loadUserData(for: trip)
                        })
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func loadUserData(for trip: Trip) {
        friendService.fetchAllFriends(tripId: trip.id)
        tripService.selectTrip(trip)

        guard let userId = userService.getUserId() else {
            print("Error: User is nil")
            return
        }
        eventService.loadUserEvents(forTrip: trip.id, userId: userId)
        chatService.setUserId(userId: userId)
        chatService.fetchChatPageCells(ids: eventService.getEventIds())
    }
}

struct TripsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripsPageView()
                .environmentObject(UserService())
                .environmentObject(ChatService())
                .environmentObject(EventsStore(events: mockEvents))
        }
    }
}
