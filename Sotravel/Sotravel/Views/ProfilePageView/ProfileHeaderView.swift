//
//  ProfileIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: ProfileHeaderViewModel

    var body: some View {
        VStack(spacing: 10) {
            ProfileImageView(imageSrc: viewModel.imageURL,
                             name: viewModel.name ?? "John Doe",
                             width: 150,
                             height: 150)

            HStack {
                Text(viewModel.name ?? "John Doe")
                    .font(.uiTitle2)
                    .fontWeight(.bold)
                NavigationLink(destination: EditProfileView(viewModel: userService.editProfileViewModel)) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
            }

            if let desc = viewModel.description, !desc.isEmpty {
                Text(desc)
                    .font(.uiHeadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            SocialMediaLinksView(viewModel: userService.socialMediaLinksVM)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileHeaderView(viewModel: ProfileHeaderViewModel()).environmentObject(UserService())
        }
    }
}
