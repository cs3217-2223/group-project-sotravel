//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

class UserService: ObservableObject {
    @Published private(set) var user: User
    @Published private(set) var profileHeaderVM: ProfileHeaderViewModel
    @Published private(set) var socialMediaLinksVM: SocialMediaLinksViewModel
    @Published private(set) var profileFriendsVM: ProfileFriendsViewModel
    @Published private(set) var editProfileViewModel: EditProfileViewModel

    private let userRepository: UserRepository

    init(userRepository: UserRepository = UserRepositoryNode()) {
        self.user = User()
        self.profileHeaderVM = ProfileHeaderViewModel()
        self.socialMediaLinksVM = SocialMediaLinksViewModel()
        self.profileFriendsVM = ProfileFriendsViewModel()
        self.editProfileViewModel = EditProfileViewModel()
        self.userRepository = userRepository
    }

    func fetchUser(id: UUID) {
        Task {
            do {
                if let fetchedUser = try await userRepository.get(id: id) {
                    DispatchQueue.main.async {
                        self.user = fetchedUser
                        self.profileHeaderVM.updateFrom(user: self.user)
                        self.socialMediaLinksVM.updateFrom(user: self.user)
                        self.profileFriendsVM.updateFrom(user: self.user)
                        self.editProfileViewModel.updateFrom(user: self.user)
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
                let success = try await userRepository.update(user: self.user)
                if !success {
                    // Handle update failure
                }
            } catch {
                print("Error updating user:", error)
                // Handle error as needed
            }
        }
    }
}
