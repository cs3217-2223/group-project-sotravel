//
//  UpdateUserApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 23/3/23.
//

import Foundation

struct UpdateUserApiModel: Encodable {
    let socials_tiktok: String?
    let socials_instagram: String?
    let socials_telegram: String?
    let first_name: String?
    let email: String?
    let image: String?
    let description: String?

    init(user: User) {
        self.socials_tiktok = user.tiktokUsername
        self.socials_instagram = user.instagramUsername
        self.socials_telegram = user.telegramUsername
        self.first_name = user.name
        self.email = user.email
        self.image = user.imageURL
        self.description = user.description
    }
}
