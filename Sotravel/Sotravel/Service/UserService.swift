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
    @Published var profileHeaderVM: ProfileHeaderViewModel
    @Published var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published var editProfileViewModel: EditProfileViewModel

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
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
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
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
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
                    alertEditProfileView()
                    return
                }
                self.updateCache(from: updatedUser)
                self.notifyAll(for: updatedUser)
            } catch {
                alertEditProfileView()
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

    func toggleEditProfileViewAlert() {
        editProfileViewModel.updateError.toggle()
    }

    func clear() {
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
        self.observers = [:]
        super.clearCache()
    }

    func changeTrip() {
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
    }

    private func initCacheAndObservers(from user: User) {
        self.initCache(from: [user])
        self.initObservers(user, [self.profileHeaderVM,
                                  self.editProfileViewModel,
                                  self.socialMediaLinksVM])
    }

    private func alertEditProfileView() {
        editProfileViewModel.updateError = true
    }
}
