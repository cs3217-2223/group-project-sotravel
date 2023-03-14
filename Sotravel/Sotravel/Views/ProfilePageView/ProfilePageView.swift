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
                        }.padding(.bottom, 10)

                        VStack(spacing: 24) {
                            Button(action: {}) {
                                Text("Change Trip")
                                    .font(.uiButton)
                                    .foregroundColor(.blue)
                            }
                            Button(action: {}) {
                                Text("Log Out")
                                    .font(.uiButton)
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
