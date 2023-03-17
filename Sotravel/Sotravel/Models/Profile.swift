//
//  Profile.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var imageURL: String
    var instagramUsername: String
    var tiktokUsername: String
    var telegramUsername: String
    var friends: [Profile]

    init(
        name: String = "",
        description: String = "",
        imageURL: String = "",
        instagramUsername: String = "",
        tiktokUsername: String = "",
        telegramUsername: String = "",
        friends: [Profile] = []
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
        self.friends = friends
    }
}
