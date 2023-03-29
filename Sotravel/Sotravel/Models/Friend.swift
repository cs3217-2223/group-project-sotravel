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

    var name: String? {
        if first_name == nil && last_name == nil {
            return nil
        } else {
            return (first_name ?? "") + (last_name ?? "")
        }
    }

    init(from friend: UserFriendApiModel) {
        // TODO: Remove this null checking shit
        self.id = UUID(uuidString: friend.id) ?? UUID()
        self.first_name = friend.firstName
        self.last_name = friend.lastName
        self.image = friend.image
        self.description = friend.description
    }

    init(id: UUID,
         first_name: String,
         last_name: String,
         description: String,
         image: String) {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.description = description
        self.image = image
    }
}
