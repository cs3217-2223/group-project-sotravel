//
//  UpdateUserApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 23/3/23.
//

import Foundation

struct UpdateUserApiModel: Encodable {
    let first_name: String?
    let last_name: String?
    let email: String?
    let image: String?
    let description: String?
    let socials_tiktok: String?
    let socials_instagram: String?
    let socials_telegram: String?

    init(user: User) {
        self.socials_tiktok = user.tiktokUsername
        self.socials_instagram = user.instagramUsername
        self.socials_telegram = user.telegramUsername
        self.first_name = user.firstName
        self.last_name = user.lastName
        self.email = user.email
        self.image = user.imageURL
        self.description = user.desc
    }
}
