//
//  CreateInvitePageViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//
import Foundation

class CreateInvitePageUserViewModel: ObservableObject {
    @Published var userId: UUID
    @Published var friends: [User]

    init(friends: [User] = [], userId: UUID = UUID()) {
        self.friends = friends
        self.userId = userId
    }

    func updateFrom(friends: [User]) {
        DispatchQueue.main.async {
            self.friends = friends
        }
    }

    func updateFrom(user: User) {
        DispatchQueue.main.async {
            self.userId = user.id
        }
    }
}
