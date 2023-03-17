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

    init(user: User, userService: UserService) {
        self.user = user
        self.userService = userService
    }

    func fetchUser(id: UUID) {
        Task {
            if let fetchedUser = await userService.fetchUser(id: id) {
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            }
        }
    }

    func updateUser() {
        Task {
            let success = await userService.updateUser(self.user)
            if !success {
                // Handle update failure
            }
        }
    }
}

class UserDataManagerStub: ObservableObject {
    @Published private(set) var user = mockUser
    private let userService = UserServiceStub()

    func fetchUser(id: UUID) {
        Task {
            if let fetchedUser = await userService.fetchUser(id: id) {
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            }
        }
    }

    func updateUser() {
        Task {
            let success = await userService.updateUser(self.user)
            if !success {
                // Handle update failure
            }
        }
    }

}
