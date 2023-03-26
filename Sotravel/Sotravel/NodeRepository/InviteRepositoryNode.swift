//
//  InviteRepositoryNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 25/3/23.
//

import Foundation
import NIOHTTP1

class InviteRepositoryNode: InviteRepository {
    private static var api = NodeApi()

    func getUserInvites(id: UUID) async throws -> [Invite] {
        let params = ["user_id": id.uuidString]
        let (status, response) = try await InviteRepositoryNode.api.get(path: .userInvites,
                                                                        params: params)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from get user invites in repository is not HTTP 200", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode([UserInviteApiModel].self, from: Data(response.utf8))
            let invites = responseModel.map {apiInvite in
                Invite(apiModel: apiInvite)
            }
            return invites
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User Invites response")
        } catch {
            throw error
        }
    }

    func updateInviteStatus() async throws {

    }

}
