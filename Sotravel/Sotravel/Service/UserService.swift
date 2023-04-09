//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import SwiftUI
import Resolver
import Combine

class UserService: ObservableObject {
    private var user: User?
    private let userId = "userIdKey"
    @Published var profileHeaderVM: ProfileHeaderViewModel
    @Published var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published var editProfileViewModel: EditProfileViewModel

    @AppStorage("LoggedIn") var isLoggedIn = false

    @Injected private var userRepository: UserRepository

    init() {
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
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
                        self.handleUserPropertyChange()
                        completion(true, fetchedUser.id)
                    }
                } else {
                    completion(false, nil)
                }
            } catch {
                print("Error fetching user:", error)
                // Handle error as needed
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
                        self.handleUserPropertyChange()
                        completion(true, fetchedUser.id)
                    }
                } else {
                    completion(false, nil)
                }
            } catch {
                print("Error fetching user:", error)
                // Handle error as needed
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
                        self.handleUserPropertyChange()
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            } catch {
                print("Error fetching user:", error)
                // Handle error as needed
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
                self.handleUserPropertyChange()
            } catch {
                print("Error updating user:", error)
                // Handle error as needed
                alertEditProfileView()
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
    }

    func changeTrip() {
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
    }

    private func alertEditProfileView() {
        editProfileViewModel.updateError = true
    }

    private func handleUserPropertyChange() {
        guard let user = user else {
            return
        }
        self.profileHeaderVM.updateFrom(user: user)
        self.socialMediaLinksVM.updateFrom(user: user)
        self.editProfileViewModel.updateFrom(user: user)
    }
}
