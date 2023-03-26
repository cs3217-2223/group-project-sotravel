//
//  EventCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol EventRepository {
    func get(id: Int) async throws -> Event
    func getUserEvents(userId: UUID) async throws -> [Event]
    func create(event: Event) async throws -> Event
    func cancelEvent(id: Int) async throws
    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws
}

enum EventRsvpStatus {
    case yes, no
}
