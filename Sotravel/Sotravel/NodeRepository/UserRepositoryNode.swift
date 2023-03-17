//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

class UserRepositoryNode: UserRepository {
    func get(id: UUID) async -> User? {
        let resp = await NodeApi.get(path: .profile, params: ["user_id": "634b6038-6594-4473-8c23-a5539400d653"])
        // Deserialize the response into a User object
        return User(name: "", telegramUsername: "")
    }

    func update(user: User) async -> Bool {
        // Make the API call to update the profile and return the result
        return false
    }
}
