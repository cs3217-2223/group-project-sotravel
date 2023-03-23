//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation
import Resolver

class UserService: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var profileHeaderVM: ProfileHeaderViewModel
    @Published private(set) var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published private(set) var profileFriendsVM: ProfileFriendsViewModel
    @Published private(set) var editProfileViewModel: EditProfileViewModel

    @Injected private var userRepository: UserRepository

    init() {
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.profileFriendsVM = ProfileFriendsViewModel()
        self.editProfileViewModel = EditProfileViewModel()
    }

    func fetchUser(id: UUID) {
        Task {
            do {
                if let fetchedUser = try await userRepository.get(id: id) {
                    DispatchQueue.main.async {
                        self.user = fetchedUser
                        self.profileHeaderVM.updateFrom(user: fetchedUser)
                        self.socialMediaLinksVM.updateFrom(user: fetchedUser)
                        self.profileFriendsVM.updateFrom(user: fetchedUser)
                        self.editProfileViewModel.updateFrom(user: fetchedUser)
                    }
                }
            } catch {
                print("Error fetching user:", error)
                // Handle error as needed
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
            } catch {
                print("Error updating user:", error)
                // Handle error as needed
            }
        }
    }
}
