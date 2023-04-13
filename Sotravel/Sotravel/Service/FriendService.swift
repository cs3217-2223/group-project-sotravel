//
//  FriendService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import Foundation
import Resolver

class FriendService: BaseCacheService<User>, ObservableObject, Subject {
    typealias ObservedData = [User]
    typealias ObserverProtocol = UsersObserver

    @Published var profileFriendsViewModel: ProfileFriendsViewModel
    @Published var createInvitePageViewModel: CreateInvitePageUserViewModel

    @Injected private var userRepository: UserRepository
    @Injected private var tripRepository: TripRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    internal var observers: [ObservedData: [ObserverProtocol]]

    override init() {
        self.profileFriendsViewModel = ProfileFriendsViewModel()
        self.createInvitePageViewModel = CreateInvitePageUserViewModel()
        self.observers = [:]
        super.init()
    }

    func fetchAllFriends(tripId: Int, for user: UUID) {
        Task {
            do {
                let fetchedFriends = try await tripRepository.getAllFriendsOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.initCache(from: filteredFriends)
                    self.initObservers(filteredFriends, [self.profileFriendsViewModel, self.createInvitePageViewModel])
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadFriends(tripId: Int, for user: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let fetchedFriends = try await tripRepository.getAllFriendsOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.updateCacheInLoop(from: filteredFriends)
                    self.notifyAll(for: filteredFriends)
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
        self.observers = [:]
    }
}
