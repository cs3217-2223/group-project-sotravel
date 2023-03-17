//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

class ProfileRepositoryNode: ProfileRepository {
    func get(id: UUID) async -> Profile? {
        let resp = await NodeApi.get(path: .profile, params: ["user_id": id.uuidString])
        // Deserialize the response into a Profile object
    }

    func update(profile: Profile) async -> Bool {
        // Make the API call to update the profile and return the result
    }
}
