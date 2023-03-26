//
//  Friend.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation

struct Friend {
    let id: UUID
    let first_name, image: String
    let description, last_name: String?
    init(from friend: UserFriendApiModel) {
        // TODO: Remove this null checking shit
        self.id = UUID(uuidString: friend.id) ?? UUID()
        self.first_name = friend.firstName
        self.last_name = friend.lastName
        self.image = friend.image
        self.description = friend.description
    }
}
