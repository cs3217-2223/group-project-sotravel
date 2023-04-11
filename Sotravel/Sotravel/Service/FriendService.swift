//
//  FriendService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import Foundation
import Resolver

class FriendService: BaseCacheService<User>, ObservableObject {
    @Published var profileFriendsViewModel: ProfileFriendsViewModel
    @Published var createInvitePageViewModel: CreateInvitePageUserViewModel

    @Injected private var userRepository: UserRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.profileFriendsViewModel = ProfileFriendsViewModel()
        self.createInvitePageViewModel = CreateInvitePageUserViewModel()
        super.init()
    }

    func fetchAllFriends(tripId: Int, for user: UUID) {
        Task {
            do {
                let fetchedFriends = try await userRepository.getAllFriendsOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.initCache(from: filteredFriends)
                    self.handlePropertyChange(fetchedFriends: filteredFriends)
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadFriends(tripId: Int, for user: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let fetchedFriends = try await userRepository.getAllFriendsOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.updateCacheInLoop(from: filteredFriends)
                    self.handlePropertyChange(fetchedFriends: filteredFriends)
                    completion(true)
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(false)
            }
        }
    }

    func createTempFriendsSocialMediaLinkVM(for friend: User) -> SocialMediaLinksViewModel {
        SocialMediaLinksViewModel(instagramUsername: friend.instagramUsername ?? "",
                                  tiktokUsername: friend.tiktokUsername ?? "",
                                  telegramUsername: friend.telegramUsername ?? "")
    }

    func clear() {
        self.clearCache()
        self.profileFriendsViewModel.clear()
        self.createInvitePageViewModel.clear()
    }

    private func handlePropertyChange(fetchedFriends: [User]) {
        self.profileFriendsViewModel.updateFrom(friends: fetchedFriends)
        self.createInvitePageViewModel.updateFrom(friends: fetchedFriends)
    }
}
