//
//  ProfileViewModelNode.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//
import Foundation

class ProfileViewModel: ProfileViewModelProtocol, ObservableObject {
    @Published private(set) var profile: Profile
    private let profileService: ProfileService

    init(profile: Profile, profileService: ProfileService) {
        self.profile = profile
        self.profileService = profileService
    }

    func fetchProfile(id: UUID) {
        Task {
            if let fetchedProfile = await profileService.fetchProfile(id: id) {
                DispatchQueue.main.async {
                    self.profile = fetchedProfile
                }
            }
        }
    }

    func updateProfile() {
        Task {
            let success = await profileService.updateProfile(self.profile)
            if !success {
                // Handle update failure
            }
        }
    }
}
