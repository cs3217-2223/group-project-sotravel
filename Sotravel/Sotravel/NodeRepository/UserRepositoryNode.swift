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
        let params = ["user_id": id.uuidString]
        let (status, response) = try await UserRepositoryNode.api.get(path: .profile,
                                                                      params: params)
        let functionName = "Get User"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(data.utf8))

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
        let functionName = "Update User"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(data.utf8))

            return try User(apiUser: responseModel)
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Update User response")
        }
    }

    func getAllFriends(id: UUID) async throws -> [Friend] {
        let params = ["user_id": id.uuidString]
        let (status, response) = try await UserRepositoryNode.api.get(path: .friends,
                                                                      params: params)
        let functionName = "Get Friends"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode([UserFriendApiModel].self, from: Data(data.utf8))

            let friends = responseModel.map { Friend(from: $0) }
            return friends
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Get Friends response")
        } catch {
            throw error
        }
    }
}
