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
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(Color.uiPrimary)
                     .edgesIgnoringSafeArea(.top)
                     .frame(height: UIScreen.main.bounds.height / 10)
                ProfileImageView(imageSrc: user.imageURL, name: user.name, width: 150, height: 150)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            }

            Text(user.name)
                .font(.uiTitle2)
                .fontWeight(.bold)

            Text(user.description ?? "")
                .font(.uiHeadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                if let telegramUsername = user.telegramUsername, !telegramUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://t.me/\(telegramUsername)") else { return }
                        UIApplication.shared.open(url)
                    }, label: {
                        Image("telegram")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                }
                if let instagramUsername = user.instagramUsername, !instagramUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://www.instagram.com/\(instagramUsername)/") else { return }
                        UIApplication.shared.open(url)
                    }, label: {
                        Image("instagram")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                }
                if let tiktokUsername = user.tiktokUsername, !tiktokUsername.isEmpty {
                    Button(action: {
                        guard let url = URL(string: "https://www.tiktok.com/@\(tiktokUsername)") else { return }
                        UIApplication.shared.open(url)
                    }, label: {
                        Image("tiktok")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
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
