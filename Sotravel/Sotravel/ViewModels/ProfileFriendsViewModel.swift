//
//  ProfileFriendsViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class ProfileFriendsViewModel: UsersObserver, ObservableObject {
    @Published var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    override func updateFrom(data: [User]) {
        DispatchQueue.main.async {
            self.friends = data
        }
    }

    func add(friend: User) {
        DispatchQueue.main.async {
            self.friends.append(friend)
        }
    }

    override func clear() {
        self.friends = []
    }
}
