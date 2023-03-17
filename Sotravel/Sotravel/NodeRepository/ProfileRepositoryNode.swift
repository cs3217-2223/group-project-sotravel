//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

class ProfileRepositoryNode: ProfileRepository {
    func get(id: UUID) async -> Profile? {
        let resp = await NodeApi.get(path: .profile, params: ["user_id": "634b6038-6594-4473-8c23-a5539400d653"])
        // Deserialize the response into a Profile object
    }

    func update(profile: Profile) async -> Bool {
        // Make the API call to update the profile and return the result
    }
}
