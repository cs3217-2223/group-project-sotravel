//
//  EventCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol EventRepository {
    func get(id: Int) async throws -> Event
    func getUserEvents(userId: UUID, tripId: Int) async throws -> [Event]
    func create(event: Event) async throws -> Event
    func cancelEvent(id: Int) async throws
    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws
}

enum EventRsvpStatus {
    case yes, no
}

class EventRepositoryStub: EventRepository {
    var dataBase = mockEventss

    func get(id: Int) async throws -> Event {
        for event in dataBase where event.id == id {
            return event
        }
        return mockEvent1
    }

    func getUserEvents(userId: UUID, tripId: Int) async throws -> [Event] {
        var events: [Event] = []
        for event in dataBase where (event.tripId == tripId
                                        && (event.hostUser == userId || event.invitedUsers.contains(userId))) {
            events.append(event)
        }
        print(events.count)
        return events
    }

    func create(event: Event) async throws -> Event {
        dataBase.append(event)
        return event
    }

    func cancelEvent(id: Int) async throws {
        dataBase.removeAll(where: { $0.id == id })
    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) async throws {

        for event in dataBase where eventId == event.id {

            event.attendingUsers.removeAll { $0 == userId }
            event.rejectedUsers.removeAll { $0 == userId }

            if status == EventRsvpStatus.no {
                event.rejectedUsers.append(userId)
            } else {
                event.attendingUsers.append(userId)
            }
        }
    }

}
