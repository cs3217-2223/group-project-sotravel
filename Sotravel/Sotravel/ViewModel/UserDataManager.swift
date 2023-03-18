//
//  ProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import SwiftUI
import Combine

class UserDataManager: ObservableObject {
    @Published private(set) var user: User
    private let userService: UserService

    init(userService: UserService = UserServiceNode(userRepository: UserRepositoryNode())) {
        self.user = User()
        self.userService = userService
    }

    func fetchUser(id: UUID) {
        Task {
            do {
                if let fetchedUser = try await userService.fetchUser(id: id) {
                    DispatchQueue.main.async {
                        print("success")
                        self.user = fetchedUser
                    }
                }
            } catch {
                print("Error fetching user:", error)
                // Handle error as needed
            }
        }
    }

    func updateUser() {
        Task {
            do {
                let success = try await userService.updateUser(self.user)
                if !success {
                    // Handle update failure
                }
            } catch {
                print("Error updating user:", error)
                // Handle error as needed
            }
        }
    }
}
