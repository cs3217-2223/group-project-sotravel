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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileHeaderView(viewModel: userService.profileHeaderVM)
                    Divider()
                    ProfileFriendsView(viewModel: userService.profileFriendsVM)
                    Spacer()
                    Divider()
                    VStack {
                        HStack {
                            Text("Settings")
                                .font(.uiTitle3)
                            Spacer()
                        }.padding(.bottom, 20)

                        VStack(spacing: 32) {
                            NavigationLink(destination: TripsPageView()) {
                                Text("Change Trip")
                                    .font(.uiHeadline)
                                Image(systemName: "airplane.departure")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.uiPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.uiPrimary, lineWidth: 1)
                            )
                            .simultaneousGesture(TapGesture().onEnded {
                                self.changeTrip()
                            })

                            NavigationLink(destination: ContentView().navigationBarBackButtonHidden()) {
                                Text("Log Out")
                                    .font(.uiHeadline)
                                    .foregroundColor(.red)
                                Image(systemName: "airplane.departure")
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                self.logOut()
                            })
                        }

                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }

    private func changeTrip() {
        guard let user = userService.user else {
            return
        }
        userService.changeTrip()
        userService.reloadUser()
        eventService.clear()
        tripService.clear()

        // Reload the trips
        tripService.loadUserTrips(userId: user.id)

        // TODO: tear down / reset chat
    }

    private func logOut() {
        userService.clear()
        eventService.clear()
        tripService.clear()

        // TODO: tear down / reset chat
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(UserService())
    }
}
