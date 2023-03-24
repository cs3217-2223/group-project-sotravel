//
//  EventPageUserViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

class EventPageUserViewModel: ObservableObject {
    @Published var userId: UUID

    init(userId: UUID = UUID()) {
        self.userId = userId
    }

    func updateFrom(user: User) {
        self.userId = user.id
    }
}
