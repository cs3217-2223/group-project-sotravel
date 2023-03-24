//
//  EventPageUserViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

struct EventPageUserViewModel {

    var userId: UUID

    init(userId: UUID = UUID()) {
        self.userId = userId
    }

    mutating func updateFrom(user: User) {
        self.userId = user.id
    }
}
