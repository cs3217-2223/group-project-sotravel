//
//  ProfileServiceNode.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

class UserServiceNode: UserService {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func fetchUser(id: UUID) async -> User? {
        await userRepository.get(id: id)
    }

    func updateUser(_ user: User) async -> Bool {
        await userRepository.update(user: user)
    }
}
