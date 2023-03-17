//
//  ProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 17/3/23.
//

import Foundation

protocol ProfileViewModelProtocol: ObservableObject {
    var profile: Profile { get }
    func fetchProfile(id: UUID)
    func updateProfile()
}
