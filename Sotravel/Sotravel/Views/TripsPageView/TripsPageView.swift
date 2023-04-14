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
                        Button(action: {
                            refreshTrip()
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.primary)
                        })
                    }
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if tripService.getTripViewModels().isEmpty {
                            Text("No trips found. Tap the refresh button to try again.")
                                .font(.uiBody)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(tripService.getTripViewModels(), id: \.id) { viewModel in
                                NavigationLink(destination: TripPageView(selectedTab: $tripService.selectedTapInCurrTrip)) {
                                    TripCardView(viewModel: viewModel)
                                }.foregroundColor(.primary)
                                .simultaneousGesture(TapGesture().onEnded {
                                    // Call loadUserData when the TripCardView is tapped
                                    self.loadUserData(for: viewModel.id)
                                })
                            }
                        }
                    }.onAppear {
                        refreshTrip()
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func loadUserData(for tripId: Int) {
        // Check if trip data has already been loaded
        if let id = tripService.getCurrTripId(), id == tripId {
            return
        }

        guard let trip = tripService.get(id: tripId) else {
            return
        }

        userService.reloadUser { success in
            if success {
                guard let userId = userService.userId else {
                    print("Fatal error, userId not found")
                    return
                }

                friendService.fetchAllFriends(tripId: trip.id, for: userId)
                tripService.selectTrip(trip)

                eventService.loadUserEvents(forTrip: trip.id, userId: userId)
                chatService.setUserId(userId: userId)

                // Store the ID of the selected trip
                tripService.lastSelectedTripId = trip.id
            } else {
                print("failed to reload User")
            }
        }
    }

    private func refreshTrip() {
        userService.reloadUser { success in
            if success {
                guard let userId = userService.userId else {
                    print("Fatal error, userId not found")
                    return
                }
                tripService.reloadUserTrips(userId: userId) {

                }
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
