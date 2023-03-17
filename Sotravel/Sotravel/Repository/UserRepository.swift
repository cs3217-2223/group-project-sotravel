//
//  UserCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol UserRepository {
    func get(id: UUID) async -> User?
    func update(user: User) async -> Bool
}
