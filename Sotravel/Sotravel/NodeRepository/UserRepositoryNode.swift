//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation
import NIOHTTP1

class UserRepositoryNode: UserRepository {
    let api = NodeApi()

    func get(id: UUID) async throws -> User? {
        let (status, response) = try await api.get(path: .profile, params: ["user_id": "634b6038-6594-4473-8c23-a5539400d653"])

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Unable to get bearer token", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(response.utf8))
            // Deserialize the response into a User object
            return try User(apiUser: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User response")
        } catch {
            throw error
        }
    }

    func update(user: User) async throws -> User? {
        // Create the API model
        let userToUpdate = UpdateUserApiModel(user: user)
        // Make the API call to update the profile and return the result
        let (status, response) = try await api.post(path: .updateProfile, data: userToUpdate.dictionary)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Unable to get bearer token", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(response.utf8))
            // Deserialize the response into a User object
            return try User(apiUser: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User response")
        }
    }
}
