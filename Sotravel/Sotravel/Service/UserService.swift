//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import SwiftUI
import Resolver
import Combine

class UserService: BaseCacheService<User>, ObservableObject, Subject {
    typealias ObservedData = User
    typealias ObserverProtocol = UserObserver

    internal var observers: [ObservedData: [ObserverProtocol]]

    private let userIdKey = "userIdKey"

    @AppStorage("LoggedIn") var isLoggedIn = false

    @Injected private var userRepository: UserRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    var currentUserId: UUID? {
        if let uuidString = UserDefaults.standard.string(forKey: userIdKey) {
            return UUID(uuidString: uuidString)
        } else {
            return nil
        }
    }

    override init() {
        self.observers = [:]
        super.init()
    }

    func getCurrentUser() -> User? {
        self.getOptional(optionalId: currentUserId)
    }

    func storeUserId(id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: userIdKey)
    }

    func logout() {
        self.isLoggedIn = false
        self.observers = [:]
        UserDefaults.standard.resetLogin()
        UserDefaults.standard.resetLastSelectedTrip()
        UserDefaults.standard.resetApiKey()
    }

    func emailSignin(email: String, password: String, completion: @escaping (Bool, UUID?) -> Void) {
        Task {
            do {
                let fetchedUser = try await userRepository.emailSignin(email: email, password: password)
                cacheUser(user: fetchedUser, completion: { success in
                    completion(success, fetchedUser?.id)
                })
            } catch {
                serviceErrorHandler.handle(error)
                completion(false, nil)
            }
        }
    }

    // TODO: Remove if unused by specified date in EmailSignUpView
    // Unused (See EmailSignUpView for detailed comments)
    func emailSignup(email: String, password: String, completion: @escaping (Bool, UUID?) -> Void) {
        Task {
            do {
                let fetchedUser = try await userRepository.emailSignup(email: email, password: password)
                cacheUser(user: fetchedUser, completion: { success in
                    completion(success, fetchedUser?.id)
                })
            } catch {
                serviceErrorHandler.handle(error)
                completion(false, nil)
            }
        }
    }

    func fetchAndCacheUserInBackground(id: UUID, completion: ((Bool) -> Void)?) {
        Task {
            do {
                let fetchedUser = try await userRepository.get(id: id)
                cacheUser(user: fetchedUser, completion: completion)
            } catch {
                serviceErrorHandler.handle(error)
                completion?(false)
            }
        }
    }

    func getUser(userId: UUID, completion: ((Bool) -> Void)? = { _ in }) async throws -> User {
        if let user = self.getOptional(optionalId: userId) {
            return user
        }

        let fetchedUser = try await userRepository.get(id: userId)
        guard let fetchedUser = fetchedUser else {
            throw SotravelError.message("Unable to get user, returned nil")
        }
        cacheUser(user: fetchedUser, completion: completion)
        return fetchedUser
    }

    private func cacheUser(user: User?, completion: ((Bool) -> Void)?) {
        if let fetchedUser = user {
            DispatchQueue.main.async {
                self.updateCache(from: fetchedUser)
                self.objectWillChange.send()
                completion?(true)
            }
        } else {
            completion?(false)
        }
    }

    func updateUser() {
        Task {
            do {
                guard let user = getCurrentUser() else {
                    return
                }
                guard let updatedUser = try await userRepository.update(user: user) else {
                    return
                }
                DispatchQueue.main.async {
                    self.updateCache(from: updatedUser)
                    self.notifyAll(for: updatedUser)
                    self.objectWillChange.send()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadUser(completion: @escaping (Bool) -> Void) {
        guard let userId = currentUserId else {
            return
        }

        fetchAndCacheUserInBackground(id: userId) { success in
            if success {
                if let user = self.getCurrentUser() {
                    self.notifyAll(for: user)
                    self.objectWillChange.send()
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func editUser(firstName: String,
                  lastName: String,
                  description: String,
                  instagramUsername: String,
                  tiktokUsername: String) {
        guard let user = getOptional(optionalId: currentUserId) else {
            return
        }
        user.updateFirstName(firstName)
        user.updateLastName(lastName)
        user.updateDesc(description)
        user.updateInstagramUsername(instagramUsername)
        user.updateTiktokUsername(tiktokUsername)
    }

    func clear() {
        self.clearAllObservers()
        self.observers = [:]
        super.clearCache()
    }

    func changeTrip() {
        self.clearAllObservers()
        super.clearCache()
    }

    func getProfileHeaderViewModel() -> ProfileHeaderViewModel? {
        guard let user = self.getCurrentUser() else {
            return nil
        }

        if let existingViewModel = self.getObservers(for: user)?.compactMap({ $0 as? ProfileHeaderViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = ProfileHeaderViewModel(user: user)
            self.addObserver(newViewModel, for: user)
            return newViewModel
        }
    }

    func getEditProfileViewModel() -> EditProfileViewModel? {
        guard let user = self.getCurrentUser() else {
            return nil
        }

        if let existingViewModel = self.getObservers(for: user)?.compactMap({ $0 as? EditProfileViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = EditProfileViewModel(user: user)
            self.addObserver(newViewModel, for: user)
            return newViewModel
        }
    }

    func getSocialMediaLinksViewModel() -> SocialMediaLinksViewModel? {
        guard let user = self.getCurrentUser() else {
            return nil
        }

        if let existingViewModel = self.getObservers(for: user)?.compactMap({ $0 as? SocialMediaLinksViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = SocialMediaLinksViewModel(user: user)
            self.addObserver(newViewModel, for: user)
            return newViewModel
        }
    }
}
