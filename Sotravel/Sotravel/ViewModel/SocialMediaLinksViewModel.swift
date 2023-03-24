//
//  SocialMediaLinksViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//

struct SocialMediaLinksViewModel {
    private(set) var instagramUsername: String
    private(set) var tiktokUsername: String
    private(set) var telegramUsername: String

    init(instagramUsername: String = "", tiktokUsername: String = "", telegramUsername: String = "") {
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
    }

    mutating func updateFrom(user: User) {
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
        self.telegramUsername = user.telegramUsername
    }
}