//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

protocol UserService {
    func fetchUser(id: UUID) async -> User?
    func updateUser(_ user: User) async -> Bool
}
