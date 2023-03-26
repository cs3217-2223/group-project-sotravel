//
//  UserFriendApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation
struct UserFriendApiModel: Codable {
    let id, firstName: String
    let image: String
    let lastName, description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case image, description
    }
}
