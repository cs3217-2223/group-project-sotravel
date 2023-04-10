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

    func emailSignin(email: String, password: String) async throws -> User? {
        let dataBody = ["email": email, "password": password]
        let (status, response) = try await UserRepositoryNode.api.post(path: .demoSignin, data: dataBody)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        let signInResponse: TelegramSignInResponse = try DecoderHelper.decodeToClass(data: data)
        return try User(apiModel: signInResponse.user)
    }

    // TODO: Remove if unused by specified date in EmailSignUpView
    // Unused (See EmailSignUpView for detailed comments)
    func emailSignup(email: String, password: String) async throws -> User? {
        let dataBody = ["email": email, "password": password]
        let (status, response) = try await UserRepositoryNode.api.post(path: .signup, data: dataBody)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        return try DecoderHelper.decodeToClass(data: data)
    }

    func get(id: UUID) async throws -> User? {
        let params = ["user_id": id.uuidString]
        let (status, response) = try await UserRepositoryNode.api.get(path: .profile, params: params)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)
        return try DecoderHelper.decodeToClass(data: data)
    }

    func update(user: User) async throws -> User? {
        let userToUpdate = UpdateUserApiModel(user: user)
        let (status, response) = try await UserRepositoryNode.api.post(path: .updateProfile,
                                                                       data: userToUpdate.dictionary)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)
        return try DecoderHelper.decodeToClass(data: data)
    }

    func getAllFriendsOnTrip(tripId: Int) async throws -> [User] {
        let params = ["trip_id": String(tripId)]
        let (status, response) = try await UserRepositoryNode.api.get(path: .friends, params: params)
        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

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
