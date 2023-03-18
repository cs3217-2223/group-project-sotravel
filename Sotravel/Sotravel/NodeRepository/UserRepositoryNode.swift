//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation
import NIOHTTP1

class UserRepositoryNode: UserRepository {
    func get(id: UUID) async throws -> User? {
        let (status, response) = try await NodeApi.get(path: .profile, params: ["user_id": "634b6038-6594-4473-8c23-a5539400d653"])
        
        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Unable to get bearer token", nil)
        }
        
        do {
            let responseModel = try JSONDecoder().decode(NodeApiUser.self, from: Data(response.utf8))
            // Deserialize the response into a User object
            return User(apiUser: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User response")
        }
        
    }

    func update(user: User) async -> Bool {
        // Make the API call to update the profile and return the result
        return false
    }
}

class UserRepoStub: UserRepository {
    let mockDataBase = [mockUser,
                        mockUser1,
                        mockUser2,
                        mockUser3,
                        mockUser4,
                        mockUser5,
                        mockUser6,
                        mockUser7,
                        mockUser8,
                        mockUser9,
                        mockUser10]

    func get(id: UUID) async -> User? {
        var res: User?
        for user in mockDataBase where user.id == id {
            res = user
        }
        return res
    }

    func update(user: User) async -> Bool {
        // Make the API call to update the profile and return the result
        return true
    }
}
