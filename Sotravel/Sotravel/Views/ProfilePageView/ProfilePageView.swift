//
//  ProfileView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var tripService: TripService
    @EnvironmentObject private var friendService: FriendService
    @EnvironmentObject private var chatService: ChatService

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileHeaderView(viewModel: userService.profileHeaderVM)
                    Divider()
                    ProfileFriendsView(viewModel: friendService.profileFriendsViewModel)
                    Spacer()
                    Divider()
                    VStack {
                        HStack {
                            Text("Settings")
                                .font(.uiTitle3)
                            Spacer()
                        }.padding(.bottom, 20)

                        VStack(spacing: 32) {
                            Button(action: {
                                self.reloadMenu()
                            }) {
                                Menu {
                                    ForEach(tripService.trips, id: \.id) { trip in
                                        Button(action: {
                                            self.loadUserData(for: trip)
                                        }) {
                                            Text(trip.title)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text("Change Trip")
                                            .font(.uiHeadline)
                                        Image(systemName: "airplane.departure")
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.uiPrimary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.uiPrimary, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }

    private func reloadMenu() {
        guard let userId = userService.getUserId() else {
            return
        }
        // Reload the trips
        tripService.reloadUserTrips(userId: userId) {

        }
    }

    private func changeTrip(completion: @escaping (Bool) -> Void) {
        userService.changeTrip()
        eventService.clear()
        tripService.clear()
        chatService.clear()
        friendService.clear()

        userService.reloadUser { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    private func loadUserData(for trip: Trip) {
        changeTrip { success in
            if success {
                friendService.fetchAllFriends(tripId: trip.id)

                guard let userId = userService.getUserId() else {
                    print("Error: User is nil")
                    return
                }
                tripService.reloadUserTrips(userId: userId) {

                }
                tripService.selectTrip(trip)
                eventService.loadUserEvents(forTrip: trip.id, userId: userId)
                chatService.setUserId(userId: userId)
            } else {
                print("failed to call changeTrip")
            }
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(UserService())
    }
}
