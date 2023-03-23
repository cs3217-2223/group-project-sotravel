//
//  ProfileIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var userService: UserService

    var body: some View {
        VStack(spacing: 10) {
            ProfileImageView(imageSrc: userService.profileHeaderVM.imageURL,
                             name: userService.profileHeaderVM.name ?? "John Doe",
                             width: 150,
                             height: 150)

            HStack {
                Text(userService.profileHeaderVM.name ?? "John Doe")
                    .font(.uiTitle2)
                    .fontWeight(.bold)
                NavigationLink(destination: EditProfileView()) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
            }

            if let desc = userService.profileHeaderVM.description, !desc.isEmpty {
                Text(desc)
                    .font(.uiHeadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            SocialMediaLinksView()
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileHeaderView().environmentObject(UserService())
        }
    }
}
