import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var tripService: TripService
    @EnvironmentObject var friendService: FriendService
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var eventService: EventService

    @State private var isTripRefreshed = false
    @State private var timeoutReached = false

    var body: some View {
        Group {
            if isTripRefreshed {
                if userService.isLoggedIn {
                    // MARK: Uncomment to navigate user to the last selected trip
                    if let lastSelectedTripId = tripService.lastSelectedTripId,
                       let lastSelectedTrip = tripService.get(id: lastSelectedTripId) {
                        TripPageView(selectedTab: $tripService.selectedTapInCurrTrip)
                            .onAppear {
                                self.loadUserData(for: lastSelectedTrip)
                            }
                    } else {
                        TripsPageView()
                    }
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {
            refreshTrip()
        }
    }

    private func loadUserData(for trip: Trip) {
        // Check if trip data has already been loaded
        if let id = tripService.getCurrTripId(), id == trip.id {
            return
        }

        userService.reloadUser { success in
            if success {
                guard let userId = userService.currentUserId else {
                    print("Fatal error, userId not found")
                    return
                }

                friendService.fetchAllFriends(tripId: trip.id, for: userId)
                tripService.selectTrip(trip)

                eventService.loadUserEvents(forTrip: trip.id, userId: userId)
                chatService.setUserId(userId: userId)

                // Store the ID of the selected trip in UserDefaults
                tripService.lastSelectedTripId = trip.id
            } else {
                print("failed to reload User")
            }
        }
    }

    private func refreshTrip() {
        let timeout: TimeInterval = 5 // Timeout in seconds

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            self.timeoutReached = true
            if !self.isTripRefreshed {
                self.isTripRefreshed = true
            }
        }

        userService.reloadUser { success in
            if success {
                guard let userId = self.userService.currentUserId else {
                    print("Fatal error, userId not found")
                    return
                }
                self.tripService.reloadUserTrips(userId: userId) { _ in
                    DispatchQueue.main.async {
                        if !self.timeoutReached {
                            self.isTripRefreshed = true
                        }
                    }
                }
            }
        }
    }
}
