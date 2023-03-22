//
//  ProfileFriendsViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//

struct ProfileFriendsViewModel {
    private(set) var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    mutating func updateFrom(user: User) {
        self.friends = user.friends
    }
}
