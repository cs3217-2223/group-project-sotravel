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

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        return try DecoderHelper.decodeToClass(data: data)
    }

    func getUserEvents(userId: UUID, tripId: Int) async throws -> [Event] {
        let params = ["user_id": userId.uuidString,
                      "trip_id": String(tripId)]
        let (status, response) = try await EventRepositoryNode.api.get(path: .userInvites, params: params)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        return try DecoderHelper.decodeToClassArray(data: data)
    }

    func create(event: Event)  async throws -> Event {
        let apiModel = UserCreateEventApiModel(from: event)
        let (status, response) = try await EventRepositoryNode.api.post(path: .createInvite, data: apiModel.dictionary)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        return try DecoderHelper.decodeToClass(data: data)
    }

    func cancelEvent(id: Int) async throws {
        let body = [
            "invite_id": String(id)
        ]
        let (status, _) = try await EventRepositoryNode.api.post(path: .cancelInvite, data: body)

        try ApiErrorHelper.handleError(status: status)
    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws {
        let body = [
            "user_id": userId.uuidString,
            "invite_id": String(eventId),
            "status": status == .yes ? "going" : "no"
        ]
        let (status, _) = try await EventRepositoryNode.api.put(path: .updateInvite, data: body)

        try ApiErrorHelper.handleError(status: status)
    }
}
