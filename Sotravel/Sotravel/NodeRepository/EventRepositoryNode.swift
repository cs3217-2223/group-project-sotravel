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
        let functionName = "Get event"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(data.utf8))
            return Event(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Get Invite response")
        } catch {
            throw error
        }
    }

    func getUserEvents(userId: UUID, tripId: Int) async throws -> [Event] {
        let params = ["user_id": userId.uuidString,
                      "trip_id": String(tripId)]
        let (status, response) = try await EventRepositoryNode.api.get(path: .userInvites, params: params)
        let functionName = "Get User events"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode([EventApiModel].self, from: Data(data.utf8))
            let events = responseModel.map { Event(apiModel: $0) }
            return events
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Get User Invites response")
        } catch {
            throw error
        }
    }

    func create(event: Event)  async throws -> Event {
        let apiModel = UserCreateEventApiModel(from: event)
        let (status, response) = try await EventRepositoryNode.api.post(path: .createInvite, data: apiModel.dictionary)
        let functionName = "Create event"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)

        do {
            let responseModel = try JSONDecoder().decode(EventApiModel.self, from: Data(data.utf8))
            return Event(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Create Invites response")
        } catch {
            throw error
        }
    }

    func cancelEvent(id: Int) async throws {
        let body = [
            "invite_id": String(id)
        ]
        let (status, _) = try await EventRepositoryNode.api.post(path: .cancelInvite, data: body)
        let functionName = "Cancel event"

        try ApiErrorHelper.handleError(location: functionName, status: status)
    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws {
        let body = [
            "user_id": userId.uuidString,
            "invite_id": String(eventId),
            "status": status == .yes ? "going" : "no"
        ]
        let (status, _) = try await EventRepositoryNode.api.put(path: .updateInvite, data: body)
        let functionName = "RSVP to event"

        try ApiErrorHelper.handleError(location: functionName, status: status)
    }
}
