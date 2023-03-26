//
//  InviteRepository.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 25/3/23.
//

import Foundation

protocol InviteRepository {
    func getUserInvites(id: UUID) async throws -> [Invite]
    func updateInviteStatus() async throws
}
