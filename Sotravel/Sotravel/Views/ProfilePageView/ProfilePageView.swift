//
//  ProfileView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfilePageView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ProfileHeaderView()
                    Divider()
                    ProfileFriendsView()
                    Spacer()
                    Divider()
                    VStack {
                        HStack {
                            Text("Settings")
                                .font(.uiTitle3)
                            Spacer()
                        }.padding(.bottom, 20)

                        VStack(spacing: 28) {
                            Button(action: {}) {
                                Text("Change Trip")
                                    .font(.uiHeadline)
                                    .foregroundColor(.blue)
                                Image(systemName: "airplane.departure")
                            }
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
        ProfilePageView().environmentObject(mockUser)
    }
}
