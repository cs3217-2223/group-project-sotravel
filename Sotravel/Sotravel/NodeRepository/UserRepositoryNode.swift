//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation
import NIOHTTP1

class UserRepositoryNode: UserRepository {
    private static var api = NodeApi()

    func get(id: UUID) async throws -> User? {
        let params = ["user_id": "003c8b4a-f831-43c8-9895-bf37da40fa95"]
        let (status, response) = try await UserRepositoryNode.api.get(path: .profile,
                                                                      params: params)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from get user in repository is not HTTP 200", nil)
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
        let (status, response) = try await UserRepositoryNode.api.post(path: .updateProfile,
                                                                       data: userToUpdate.dictionary)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from update user in repository is not HTTP 200", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(response.utf8))
            // Deserialize the response into a User object
            return try User(apiUser: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Update User response")
        }
    }
}
