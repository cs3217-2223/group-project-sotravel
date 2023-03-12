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

            Text(user.name)
                .font(.uiTitle2)
                .fontWeight(.bold)

            Text(user.description)
                .font(.uiHeadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                if !user.telegramUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://t.me/\(user.telegramUsername)") else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Image("telegram")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }

                if !user.instagramUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://www.instagram.com/\(user.instagramUsername)/") else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Image("instagram")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }

                if !user.tiktokUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://www.tiktok.com/@\(user.tiktokUsername)") else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Image("tiktok")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }.padding(.vertical, 12)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView().environmentObject(mockUser)
    }
}
