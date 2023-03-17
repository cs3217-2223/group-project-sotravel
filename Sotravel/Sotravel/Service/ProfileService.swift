//
//  ProfileService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

protocol ProfileService {
    func fetchProfile(id: UUID) async -> Profile?
    func updateProfile(_ profile: Profile) async -> Bool
}
