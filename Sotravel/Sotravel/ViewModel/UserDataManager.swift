//
//  ProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

class UserDataManager: ObservableObject {
    @Published private(set) var user: User
    private let userService: UserService

    init(user: User = mockUser, userService: UserService = UserServiceStub()) {
        self.user = user
        self.userService = userService
    }

    func fetchUser(id: UUID) throws {
        Task {
            if let fetchedUser = try await userService.fetchUser(id: id) {
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            }
        }
    }

    func updateUser() throws {
        Task {
            let success = try await userService.updateUser(self.user)
            if !success {
                // Handle update failure
            }
        }
    }
}
