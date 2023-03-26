//
//  EventRepositoryNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 25/3/23.
//

import Foundation
import NIOHTTP1

class EventRepositoryNode: EventRepository {
    private static var api = NodeApi()

    func get(id: Int) async throws -> Event {
        let params = ["invite_id": String(id)]
        let (status, response) = try await EventRepositoryNode.api.get(path: .inviteById, params: params)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from get user invites in repository is not HTTP 200", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(response.utf8))
            return Event(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get Invite response")
        } catch {
            throw error
        }
    }

    func getUserEvents(userId: UUID) async throws -> [Event] {
        let params = ["user_id": userId.uuidString]
        let (status, response) = try await EventRepositoryNode.api.get(path: .userInvites, params: params)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from get user invites in repository is not HTTP 200", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode([EventApiModel].self, from: Data(response.utf8))
            let events = responseModel.map {apiInvite in
                Event(apiModel: apiInvite)
            }
            return events
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User Invites response")
        } catch {
            throw error
        }
    }

    func create(event: Event)  async throws -> Event {
        let apiModel = UserCreateEventApiModel(from: event)
        let (status, response) = try await EventRepositoryNode.api.get(path: .userInvites, data: apiModel.dictionary)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Response from create invites in repository is not HTTP 200", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(response.utf8))
            return Event(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Get User Invites response")
        } catch {
            throw error
        }
    }

    func cancelEvent(id: Int) async throws {

    }

    func rsvpToEvent(id: Int, status: EventRsvpStatus) async throws {

    }

}
