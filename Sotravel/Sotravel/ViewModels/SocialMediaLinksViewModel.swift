//
//  SocialMediaLinksViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class SocialMediaLinksViewModel: ObservableObject {
    @Published var instagramUsername: String?
    @Published var tiktokUsername: String?
    @Published var telegramUsername: String?

    init(instagramUsername: String = "", tiktokUsername: String = "", telegramUsername: String = "") {
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
    }

    func updateFrom(user: User) {
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
        self.telegramUsername = user.telegramUsername
    }
}
