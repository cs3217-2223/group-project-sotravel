//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

class ProfileRepositoryNode: ProfileRepository {
    func get(id: UUID) async -> Profile? {
        let userId = "634b6038-6594-4473-8c23-a5539400d653"
        do {
            let resp = try await NodeApi.get(path: .profile, params: ["user_id": userId])
            print(resp)
            // Deserialize the response into a Profile object
            return Profile()
        } catch {
            return nil
        }

    }

    func update(profile: Profile) async -> Bool {
        // Make the API call to update the profile and return the result
        return false
    }
}
