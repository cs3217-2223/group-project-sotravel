//
//  CreateInvitePageViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

struct CreateInvitePageUserViewModel {
    var friends: [User]

    init(friends: [User] = []) {
        self.friends = friends
    }

    mutating func updateFrom(user: User) {
        self.friends = user.friends
    }
}
