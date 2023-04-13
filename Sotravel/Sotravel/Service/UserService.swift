//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import SwiftUI
import Resolver
import Combine

class UserService: ObservableObject, Subject {
    typealias ObservedData = User
    typealias ObserverProtocol = UserObserver

    internal var observers: [ObservedData: [ObserverProtocol]]

    private var user: User?
    private let userId = "userIdKey"
    @Published var profileHeaderVM: ProfileHeaderViewModel
    @Published var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published var editProfileViewModel: EditProfileViewModel

    @AppStorage("LoggedIn") var isLoggedIn = false

    @Injected private var userRepository: UserRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    init() {
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
        self.observers = [:]
    }

    func getUser() -> User? {
        user
    }

    func getUserId() -> UUID? {
        user?.id
    }

    func storeUserId(id: UUID) {
        UserDefaults.standard.set(id.uuidString, forKey: userId)
    }

    func logout() {
        self.user = nil
        self.isLoggedIn = false
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
        UserDefaults.standard.resetLogin()
        UserDefaults.standard.resetLastSelectedTrip()
        UserDefaults.standard.resetApiKey()
    }

    func getStoredUserId() -> UUID? {
        if let uuidString = UserDefaults.standard.string(forKey: userId) {
            return UUID(uuidString: uuidString)
        } else {
            return nil
        }
    }

    func emailSignin(email: String, password: String, completion: @escaping (Bool, UUID?) -> Void) {
        Task {
            do {
                if let fetchedUser = try await userRepository.emailSignin(email: email, password: password) {
                    DispatchQueue.main.async {
                        self.user = fetchedUser
                        self.initObservers(fetchedUser, [self.profileHeaderVM,
                                                         self.editProfileViewModel,
                                                         self.socialMediaLinksVM])
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
                        self.user = fetchedUser
                        self.initObservers(fetchedUser, [self.profileHeaderVM, self.editProfileViewModel, self.socialMediaLinksVM])
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
                        self.user = fetchedUser
                        self.initObservers(fetchedUser, [self.profileHeaderVM, self.editProfileViewModel, self.socialMediaLinksVM])
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
                guard let user = user else {
                    return
                }
                guard let updatedUser = try await userRepository.update(user: user) else {
                    alertEditProfileView()
                    return
                }
                self.user = updatedUser
                self.notifyAll(for: user)
            } catch {
                alertEditProfileView()
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadUser(completion: @escaping (Bool) -> Void) {
        guard let userId = getStoredUserId() else {
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
        self.user?.updateFirstName(firstName)
        self.user?.updateLastName(lastName)
        self.user?.updateDesc(description)
        self.user?.updateInstagramUsername(instagramUsername)
        self.user?.updateTiktokUsername(tiktokUsername)
    }

    func toggleEditProfileViewAlert() {
        editProfileViewModel.updateError.toggle()
    }

    func clear() {
        self.user = nil
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
        self.observers = [:]
    }

    func changeTrip() {
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
    }

    private func alertEditProfileView() {
        editProfileViewModel.updateError = true
    }
}
