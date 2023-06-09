//
//  Repositories+Injection.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 22/3/23.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerRepositories() {
        register { UserRepositoryNode() }.implements(UserRepository.self)
        register { EventRepositoryNode() }.implements(EventRepository.self)
        register { TripRepositoryNode() }.implements(TripRepository.self)
        register { ChatRepositoryFirebase() }.implements(ChatRepository.self)
    }
}
