//
//  ProfileServiceNode.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

class ProfileServiceNode: ProfileService {
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func fetchProfile(id: UUID) async -> Profile? {
        await profileRepository.get(id: id)
    }

    func updateProfile(_ profile: Profile) async -> Bool {
        await profileRepository.update(profile: profile)
    }
}
