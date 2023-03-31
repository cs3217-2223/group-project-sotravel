//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation
import Resolver
import Combine

class UserService: ObservableObject {
    private var user: User?
    @Published var profileHeaderVM: ProfileHeaderViewModel
    @Published var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published var editProfileViewModel: EditProfileViewModel
    @Published var eventPageViewModel: EventPageUserViewModel
    @Published var eventStatusButtonViewModel: EventStatusButtonUserViewModel

    @Injected private var userRepository: UserRepository

    init() {
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.editProfileViewModel = EditProfileViewModel()
        self.eventPageViewModel = EventPageUserViewModel()
        self.eventStatusButtonViewModel = EventStatusButtonUserViewModel()
    }

    // Should not call this
    func getUser() -> User? {
        user
    }

    func getUserId() -> UUID? {
        user?.id
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
                    // handle update failure
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

    func reloadUser() {
        Task {
            do {
                guard let user = user else {
                    return
                }
                guard let updatedUser = try await userRepository.update(user: user) else {
                    // handle update failure
                    return
                }
                self.user = updatedUser
                self.handleUserPropertyChange()
            } catch {
                print("Error updating user:", error)
                // Handle error as needed
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
        self.eventPageViewModel.clear()
        self.eventStatusButtonViewModel.clear()
    }

    func changeTrip() {
        self.profileHeaderVM.clear()
        self.socialMediaLinksVM.clear()
        self.editProfileViewModel.clear()
        self.eventPageViewModel.clear()
        self.eventStatusButtonViewModel.clear()
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
        self.eventPageViewModel.updateFrom(user: user)
        self.eventStatusButtonViewModel.updateFrom(user: user)
    }
}
