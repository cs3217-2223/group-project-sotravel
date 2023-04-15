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

    @Injected private var tripRepository: TripRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    internal var observers: [ObservedData: [ObserverProtocol]]

    override init() {
        self.observers = [:]
        super.init()
    }

    func getProfileFriendsViewModel() -> ProfileFriendsViewModel {
        let friends = self.getAll()

        if let existingViewModel = self.getObservers(for: friends)?.compactMap({ $0 as? ProfileFriendsViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = ProfileFriendsViewModel(friends: friends)
            self.addObserver(newViewModel, for: friends)
            return newViewModel
        }
    }

    func getCreateInvitePageViewModel() -> CreateInvitePageViewModel? {
        let friends = self.getAll()

        if let existingViewModel = self.getObservers(for: friends)?.compactMap({ $0 as? CreateInvitePageViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = CreateInvitePageViewModel(friends: friends)
            self.addObserver(newViewModel, for: friends)
            return newViewModel
        }
    }

    func fetchAllFriends(tripId: Int, for user: UUID) {
        Task {
            do {
                let fetchedFriends = try await tripRepository.getAllUsersOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.initCache(from: filteredFriends)
                    self.objectWillChange.send()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadFriends(tripId: Int, for user: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let fetchedFriends = try await tripRepository.getAllUsersOnTrip(tripId: tripId)
                DispatchQueue.main.async {
                    let filteredFriends = fetchedFriends.filter { $0.id != user }
                    self.updateCacheInLoop(from: filteredFriends)
                    self.notifyAll(for: filteredFriends)
                    self.objectWillChange.send()
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
        self.observers = [:]
    }
}
