//
//  SocialMediaLinksViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class SocialMediaLinksViewModel: UserObserver, ObservableObject {
    @Published var instagramUsername: String?
    @Published var tiktokUsername: String?
    @Published var telegramUsername: String?

    init(instagramUsername: String = "", tiktokUsername: String = "", telegramUsername: String = "") {
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
    }

    init(user: User) {
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
        self.telegramUsername = user.telegramUsername
    }

    override func updateFrom(data: User) {
        DispatchQueue.main.async {
            self.instagramUsername = data.instagramUsername
            self.tiktokUsername = data.tiktokUsername
            self.telegramUsername = data.telegramUsername
        }
    }

    override func clear() {
        self.instagramUsername = ""
        self.tiktokUsername = ""
        self.telegramUsername = ""
    }
}
