import SwiftUI

struct TripsPageView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var eventService: EventService
    @EnvironmentObject var tripService: TripService
    @EnvironmentObject var friendService: FriendService

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("My Trips")
                            .font(.uiTitle1)
                        Spacer()
                    }
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(tripService.getTrips(), id: \.id) { trip in
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
    }

    private func loadUserData(for trip: Trip) {
        userService.reloadUser { success in
            if success {
                guard let userId = userService.getUserId() else {
                    print("Fatal error, userId not found")
                    return
                }

                friendService.fetchAllFriends(tripId: trip.id)
                tripService.selectTrip(trip)

                eventService.loadUserEvents(forTrip: trip.id, userId: userId)
                chatService.setUserId(userId: userId)
            } else {
                print("failed to reload User")
            }

        }
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
