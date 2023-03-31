//
//  FriendService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import Foundation
import Resolver

class FriendService: ObservableObject {

    private var friendsCache: [UUID: User]

    @Injected private var userRepository: UserRepository

    init() {
        self.friendsCache = [:]
    }

    func getFriend(id: UUID) -> User? {
        mockUser1
    }
}
