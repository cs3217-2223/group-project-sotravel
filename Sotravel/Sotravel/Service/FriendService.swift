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
    @Injected private var userService: UserService
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    internal var observers: [ObservedData: [ObserverProtocol]]

    private var tasks: [Task<Void, Never>] = []

    override init() {
        self.observers = [:]
        super.init()
    }

    func getProfileFriendsViewModel() -> ProfileFriendsViewModel {
        let friends = self.getAll()

        if let existingViewModel = self.getObservers(for: friends)?
            .compactMap({ $0 as? ProfileFriendsViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = ProfileFriendsViewModel(friends: friends)
            self.addObserver(newViewModel, for: friends)
            return newViewModel
        }
    }

    func getCreateInvitePageViewModel() -> CreateInvitePageViewModel? {
        let friends = self.getAll()

        if let existingViewModel = self.getObservers(for: friends)?
            .compactMap({ $0 as? CreateInvitePageViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = CreateInvitePageViewModel(friends: friends)
            self.addObserver(newViewModel, for: friends)
            return newViewModel
        }
    }

    func fetchAllFriends(tripId: Int, for user: UUID) {
        let task = Task {
            do {
                let fetchedFriendIds = try await tripRepository.getAllUsersOnTrip(tripId: tripId)
                let filteredFriendIds = fetchedFriendIds.filter { $0 != user }
                let friends = try await getUsersFromUserIds(userIds: filteredFriendIds)
                self.initCache(from: friends)
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
        tasks.append(task)
    }

    func reloadFriends(tripId: Int, for user: UUID, completion: @escaping (Bool) -> Void) {
        let task = Task {
            do {
                let fetchedFriendIds = try await tripRepository.getAllUsersOnTrip(tripId: tripId)
                let filteredFriendIds = fetchedFriendIds.filter { $0 != user }
                let friends = try await getUsersFromUserIds(userIds: filteredFriendIds)
                self.updateCacheInLoop(from: friends)
                self.notifyAll(for: friends)
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                    completion(true)
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(false)
            }
        }
        tasks.append(task)
    }

    func createTempFriendsSocialMediaLinkVM(for friend: User) -> SocialMediaLinksViewModel {
        SocialMediaLinksViewModel(instagramUsername: friend.instagramUsername ?? "",
                                  tiktokUsername: friend.tiktokUsername ?? "",
                                  telegramUsername: friend.telegramUsername ?? "")
    }

    func getUsersFromUserIds(userIds: [UUID]) async throws -> [User] {
        let result: [User] = []
        return try await withThrowingTaskGroup(of: User.self, body: {group in
            for id in userIds {
                group.addTask { try await self.userService.getUser(userId: id) }
            }
            return try await group.reduce(into: result) { acc, curr in
                acc.append(curr)
            }
        })
        //        var users: [User] = []
        //        for id in userIds {
        //            let user = try await self.userService.getUser(userId: id)
        //            users.append(user)
        //        }
        //        return users
    }

    func clear() {
        // Cancel all tasks
        for task in tasks {
            task.cancel()
        }
        tasks.removeAll()

        self.clearCache()
        self.clearAllObservers()
        self.observers = [:]
    }
}
