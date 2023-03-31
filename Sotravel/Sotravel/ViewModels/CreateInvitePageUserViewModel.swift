//
//  CreateInvitePageViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//
import Foundation

class CreateInvitePageUserViewModel: ObservableObject {
    @Published var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    func updateFrom(friends: [User]) {
        DispatchQueue.main.async {
            self.friends = friends
        }
    }

    func clear() {
        self.friends = []
    }
}
