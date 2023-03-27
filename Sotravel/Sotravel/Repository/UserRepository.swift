//
//  UserCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol UserRepository {
    func get(id: UUID) async throws -> User?
    func getAllFriends(id: UUID) async throws -> [Friend]
    func update(user: User) async throws -> User?
}

class UserRepositoryStub: UserRepository {
    let dataBase: [User]

    init() {
        self.dataBase = mockFriends + [mockUser]
    }

    func get(id: UUID) async throws -> User? {
        for user in dataBase where id == user.id {
            return user
        }
        return mockUser
    }

    func getAllFriends(id: UUID) async throws -> [Friend] {
        mockFriendss
    }

    func update(user: User) async throws -> User? {
        var updatedUser = mockUser
        updatedUser.updateDesc(user.desc ?? "")
        updatedUser.updateLastName(user.lastName ?? "")
        updatedUser.updateFirstName(user.firstName ?? "")
        updatedUser.updateTiktokUsername(user.tiktokUsername ?? "")
        updatedUser.updateInstagramUsername(user.instagramUsername ?? "")
        return updatedUser
    }
}
