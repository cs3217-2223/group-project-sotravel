//
//  ProfileView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject private var userService: UserService
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
                            Button(action: {}) {
                                Text("Log Out")
                                    .font(.uiHeadline)
                                    .foregroundColor(.red)
                            }
                        }

                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(UserService())
    }
}
