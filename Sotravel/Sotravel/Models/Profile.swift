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
    var imageURL: URL
    var instagramUsername: String
    var tiktokUsername: String
    var friends: [Profile]
}
