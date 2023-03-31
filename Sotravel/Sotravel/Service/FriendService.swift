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
    @Published var profileFriendsViewModel: ProfileFriendsViewModel
    @Published var createInvitePageViewModel: CreateInvitePageUserViewModel

    @Injected private var userRepository: UserRepository

    func getFriend(id: UUID) -> User? {
        friendsCache[id]
    }

    init() {
        self.profileFriendsViewModel = ProfileFriendsViewModel()
        self.createInvitePageViewModel = CreateInvitePageUserViewModel()
        self.friendsCache = [:]
    }

    func fetchAllFriends(tripId: Int, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let fetchedFriends = try await userRepository.getAllFriendsOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    self.initCache(friends: fetchedFriends)
                    self.handlePropertyChange(fetchedFriends: fetchedFriends)
                    completion(true)
                }
            } catch {
                print("Error fetching friends:", error)
                completion(false)
            }
        }
    }

    func clear() {
        self.friendsCache = [:]
        self.profileFriendsViewModel.clear()
        self.createInvitePageViewModel.clear()
    }

    private func initCache(friends: [User]) {
        for friend in friends {
            friendsCache[friend.id] = friend
        }
    }

    private func handlePropertyChange(fetchedFriends: [User]) {
        self.profileFriendsViewModel.updateFrom(friends: fetchedFriends)
        self.createInvitePageViewModel.updateFrom(friends: fetchedFriends)
    }
}
