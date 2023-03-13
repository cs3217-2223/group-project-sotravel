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
            VStack {
                ProfileHeaderView()
                Divider()
                ProfileFriendsView()
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView().environmentObject(mockUser)
    }
}
