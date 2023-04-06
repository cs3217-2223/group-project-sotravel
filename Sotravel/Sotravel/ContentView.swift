import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var tripService: TripService
    @EnvironmentObject var friendService: FriendService
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var eventService: EventService

    @State private var isTripRefreshed = false
    @State private var timeoutReached = false

    // MARK: Uncomment to reset login status
    //    init() {
    //        UserDefaults.standard.resetLogin()
    //    }

    var body: some View {
        Group {
            if isTripRefreshed {
                if userService.isLoggedIn {
                    if let mostRecentTrip = tripService.getMostRecentTrip() {
                        TripPageView(selectedTab: $tripService.selectedTapInCurrTrip)
                            .onAppear {
                                self.loadUserData(for: mostRecentTrip)
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
                guard let userId = self.userService.getUserId() else {
                    print("Fatal error, userId not found")
                    return
                }
                self.tripService.reloadUserTrips(userId: userId) {
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
