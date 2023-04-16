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
                    if let vm = userService.getProfileHeaderViewModel() {
                        ProfileHeaderView(viewModel: vm)
                    }
                    Divider()
                    if let vm = friendService.getProfileFriendsViewModel() {
                        ProfileFriendsView(viewModel: vm)
                    } else {

                    }
                    Spacer()
                    Divider()
                    VStack {
                        HStack {
                            Text("Current Trip")
                                .font(.uiTitle3)
                            Spacer()
                            Button(action: {
                                changeTrip()
                            }) {
                                HStack(spacing: 0) {
                                    Text("Switch")
                                        .font(.uiHeadline)
                                        .lineLimit(1)
                                        .padding(.trailing, 4) // Add padding to increase tap area
                                        .background(Color(UIColor.systemBackground)) // Adjust the clickable area
                                    Image(systemName: "repeat")
                                }
                            }
                        }
                        .padding(.bottom, 4)
                        .zIndex(1)

                        VStack(spacing: 16) {
                            if let currTrip = self.tripService.getCurrTrip(), let viewModel = tripService.getTripViewModel(from: currTrip.id) {
                                TripCardView(viewModel: viewModel)
                            }
                            //                            Button(action: {
                            //                                changeTrip(completion: { _ in })
                            //                            }) {
                            //                                HStack {
                            //                                    Text("Change Trip")
                            //                                        .font(.uiHeadline)
                            //                                        .lineLimit(1)
                            //                                    Spacer()
                            //                                    Image(systemName: "airplane.departure")
                            //                                }
                            //                                .frame(maxWidth: .infinity)
                            //                                .padding()
                            //                                .foregroundColor(.uiPrimary)
                            //                                .overlay(
                            //                                    RoundedRectangle(cornerRadius: 8)
                            //                                        .stroke(Color.uiPrimary, lineWidth: 1)
                            //                                )
                            //                            }
                            Button(action: {
                                logout()
                            }) {
                                Text("Log Out")
                                    .font(.uiButton)
                                    .foregroundColor(.red)
                            }.padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }

    private func reloadMenu() {
        guard let userId = userService.currentUserId else {
            return
        }
        // Reload the trips
        tripService.reloadUserTrips(userId: userId) { _ in

        }
    }

    private func logout() {
        eventService.clear()
        tripService.clear()
        chatService.clear()
        friendService.clear()
        userService.logout()
    }

    private func changeTrip() {
        eventService.clear()
        tripService.clear()
        chatService.clear()
        friendService.clear()
        userService.changeTrip()
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(UserService())
    }
}
