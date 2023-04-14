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

    var userId: UUID? {
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

    func getUser() -> User? {
        self.getOptional(optionalId: userId)
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
                if let fetchedUser = try await userRepository.emailSignin(email: email, password: password) {
                    DispatchQueue.main.async {
                        self.initCacheAndObservers(from: fetchedUser)
                        completion(true, fetchedUser.id)
                    }
                } else {
                    completion(false, nil)
                }
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
                if let fetchedUser = try await userRepository.emailSignup(email: email, password: password) {
                    DispatchQueue.main.async {
                        self.initCacheAndObservers(from: fetchedUser)
                        completion(true, fetchedUser.id)
                    }
                } else {
                    completion(false, nil)
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(false, nil)
            }
        }
    }

    func fetchUser(id: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                if let fetchedUser = try await userRepository.get(id: id) {
                    DispatchQueue.main.async {
                        self.initCacheAndObservers(from: fetchedUser)
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(false)
            }
        }
    }

    func updateUser() {
        Task {
            do {
                guard let user = getOptional(optionalId: userId) else {
                    return
                }
                guard let updatedUser = try await userRepository.update(user: user) else {
                    return
                }
                DispatchQueue.main.async {
                    self.updateCache(from: updatedUser)
                    self.notifyAll(for: updatedUser)
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadUser(completion: @escaping (Bool) -> Void) {
        guard let userId = userId else {
            return
        }

        fetchUser(id: userId) { success in
            if success {
                if let user = self.getUser() {
                    self.notifyAll(for: user)
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
        guard let user = getOptional(optionalId: userId) else {
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
    }

    func getProfileHeaderViewModel() -> ProfileHeaderViewModel? {
        guard let user = self.getUser() else {
            return nil
        }
        return self.getObservers(for: user)?.compactMap { $0 as? ProfileHeaderViewModel }.first
    }

    func getEditProfileViewModel() -> EditProfileViewModel? {
        guard let user = self.getUser() else {
            return nil
        }
        return self.getObservers(for: user)?.compactMap { $0 as? EditProfileViewModel }.first
    }

    func getSocialMediaLinksViewModel() -> SocialMediaLinksViewModel? {
        guard let user = self.getUser() else {
            return nil
        }
        return self.getObservers(for: user)?.compactMap { $0 as? SocialMediaLinksViewModel }.first
    }

    private func initCacheAndObservers(from user: User) {
        self.initCache(from: [user])
        let profileHeaderViewModel = ProfileHeaderViewModel(user: user)
        let editProfileViewModel = EditProfileViewModel(user: user)
        let socialMediaLinksViewModel = SocialMediaLinksViewModel(user: user)
        self.initObservers(user, [profileHeaderViewModel, editProfileViewModel, socialMediaLinksViewModel])
    }
}
