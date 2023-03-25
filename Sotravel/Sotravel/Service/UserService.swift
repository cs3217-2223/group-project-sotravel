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
    var user: User?
    @Published var profileHeaderVM: ProfileHeaderViewModel
    @Published var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published var profileFriendsVM: ProfileFriendsViewModel
    @Published var editProfileViewModel: EditProfileViewModel
    @Published var createInvitePageViewModel: CreateInvitePageUserViewModel
    @Published var eventPageViewModel: EventPageUserViewModel

    @Injected private var userRepository: UserRepository

    init() {
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.profileFriendsVM = ProfileFriendsViewModel()
        self.editProfileViewModel = EditProfileViewModel()
        self.createInvitePageViewModel = CreateInvitePageUserViewModel()
        self.eventPageViewModel = EventPageUserViewModel()
    }

    func fetchUser(id: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                if let fetchedUser = try await userRepository.get(id: id) {
                    DispatchQueue.main.async {
                        self.user = fetchedUser
                        self.handleUserPropertyChange()
                        print("success")
                        completion(true)
                    }
                } else {
                    print("fail")
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

    private func alertEditProfileView() {
        editProfileViewModel.updateError = true
    }

    private func handleUserPropertyChange() {
        guard let user = user else {
            return
        }
        self.profileHeaderVM.updateFrom(user: user)
        self.socialMediaLinksVM.updateFrom(user: user)
        self.profileFriendsVM.updateFrom(user: user)
        self.editProfileViewModel.updateFrom(user: user)
        self.createInvitePageViewModel.updateFrom(user: user)
        self.eventPageViewModel.updateFrom(user: user)
    }
}
