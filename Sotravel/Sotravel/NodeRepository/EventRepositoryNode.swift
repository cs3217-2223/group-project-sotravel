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

        try handleError(location: "Get event", status: status)
        let data = try handleNilResponse(location: "Get event", data: response)

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(data.utf8))
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
        let functionName = "Get event"

        try handleError(location: functionName, status: status)
        let data = try handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode([EventApiModel].self, from: Data(data.utf8))
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
        let (status, response) = try await EventRepositoryNode.api.post(path: .createInvite, data: apiModel.dictionary)
        let functionName = "Create event"

        try handleError(location: functionName, status: status)
        let data = try handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(data.utf8))
            return Event(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to parse Create Invites response")
        } catch {
            throw error
        }
    }

    func cancelEvent(id: Int) async throws {

    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws {
        let body = [
            "user_id": userId.uuidString,
            "invite_id": String(eventId),
            "status": status == .yes ? "going" : "no"
        ]
        let (status, response) = try await EventRepositoryNode.api.put(path: .updateInvite, data: body)
        let functionName = "RSVP to event"

        try handleError(location: functionName, status: status)
    }

    func handleError(location: String, status: HTTPResponseStatus) throws {
        if status == HTTPResponseStatus.unauthorized {
            throw SotravelError.AuthorizationError("[\(location)]: Call was unauthorized", nil)
        }
        if status != HTTPResponseStatus.ok {
            throw SotravelError.NetworkError("[\(location)]: Call failed", nil)
        }
    }

    func handleNilResponse(location: String, data: String?) throws -> String {
        if data == nil {
            throw SotravelError.NetworkError("[\(location)]: Call replied with nil data", nil)
        } else {
            return data!
        }
    }

}
