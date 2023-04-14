//
//  CreateInvitePageViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//
import Foundation

class CreateInvitePageViewModel: UsersObserver, ObservableObject {
    @Published var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    override func updateFrom(data: [User]) {
        DispatchQueue.main.async {
            self.friends = data
        }
    }

    override func clear() {
        self.friends = []
    }
}
