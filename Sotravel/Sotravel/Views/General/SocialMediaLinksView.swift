//
//  SocialMediaLinksview.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct SocialMediaLinksView: View {
    @EnvironmentObject private var userService: UserService
    var body: some View {
        HStack(spacing: 20) {
            if let telegramUsername = userService.socialMediaLinksVM.telegramUsername, !telegramUsername.isEmpty {
                Button(action: {
                    guard let url = URL(string: "https://t.me/\(telegramUsername)") else { return }
                    UIApplication.shared.open(url)
                }, label: {
                    Image("telegram")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
            }
            if let instagramUsername = userService.socialMediaLinksVM.instagramUsername, !instagramUsername.isEmpty {
                Button(action: {
                    guard let url = URL(string: "https://www.instagram.com/\(instagramUsername)/") else { return }
                    UIApplication.shared.open(url)
                }, label: {
                    Image("instagram")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
            }
            if let tiktokUsername = userService.socialMediaLinksVM.tiktokUsername, !tiktokUsername.isEmpty {
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

struct SocialMediaLinksView_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaLinksView().environmentObject(UserService())
    }
}
