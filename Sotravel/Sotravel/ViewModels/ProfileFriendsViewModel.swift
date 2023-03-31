//
//  ProfileFriendsViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class ProfileFriendsViewModel: ObservableObject {
    @Published var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    func updateFrom(friends: [User]) {
        DispatchQueue.main.async {
            self.friends = friends
        }
    }

    func add(friend: User) {
        DispatchQueue.main.async {
            self.friends.append(friend)
        }
    }

    func clear() {
        self.friends = []
    }
}
