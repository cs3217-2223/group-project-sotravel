//
//  UserCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol ProfileRepository {
    func get(id: UUID) async -> Profile?
    func update(profile: Profile) async -> Bool
}
