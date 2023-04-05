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
        let functionName = "Get User"
        let params = ["user_id": id.uuidString]
        let (status, response) = try await UserRepositoryNode.api.get(path: .profile, params: params)

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)
        return try DecoderHelper.decodeToClass(functionName: functionName, data: data, convertFrom: NodeApiUser.self)
    }

    func update(user: User) async throws -> User? {
        let functionName = "Update User"
        let userToUpdate = UpdateUserApiModel(user: user)
        let (status, response) = try await UserRepositoryNode.api.post(path: .updateProfile,
                                                                       data: userToUpdate.dictionary)

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)
        return try DecoderHelper.decodeToClass(functionName: functionName, data: data, convertFrom: NodeApiUser.self)
    }

    func getAllFriendsOnTrip(tripId: Int) async throws -> [User] {
        let functionName = "Get Friends"
        let params = ["trip_id": String(tripId)]
        let (status, response) = try await UserRepositoryNode.api.get(path: .friends, params: params)
        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let friendIds = try JSONDecoder().decode([String].self, from: Data(data.utf8))
            let results: [User] = []

            return try await withThrowingTaskGroup(of: (User?).self) {group in
                for id in friendIds {
                    guard let idAsUUID = UUID(uuidString: id) else {
                        continue
                    }
                    group.addTask { try await self.get(id: idAsUUID) }
                }

                return try await group.reduce(into: results) {acc, curr in
                    if let curr = curr {
                        acc.append(curr)
                    }
                }
            }
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Get Friends response")
        } catch {
            throw error
        }
    }
}
