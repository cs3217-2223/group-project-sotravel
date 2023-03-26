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
