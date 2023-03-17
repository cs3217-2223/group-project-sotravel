//
//  ProfileIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var user: User

    var body: some View {
        VStack(spacing: 10) {
            ProfileImageView(imageSrc: user.imageURL, name: user.name, width: 150, height: 150)

            HStack {
                Text(user.name)
                    .font(.uiTitle2)
                    .fontWeight(.bold)
                NavigationLink(destination: EditProfileView()) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
            }

            if !user.description.isEmpty {
                Text(user.description)
                    .font(.uiHeadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            SocialMediaLinksView(user: user)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileHeaderView().environmentObject(mockUser)
        }
    }
}
