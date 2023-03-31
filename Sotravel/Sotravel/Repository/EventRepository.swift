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
    var dataBase = mockEvents
    var index = 999

    func get(id: Int) async throws -> Event {
        for event in dataBase where event.id == id {
            return event
        }
        return mockEvent1
    }

    func getUserEvents(userId: UUID, tripId: Int) async throws -> [Event] {
        var events: [Event] = []
        for event in dataBase where (event.hostUser == userId || event.invitedUsers.contains(userId)) {
            events.append(event)
        }
        return events
    }

    func create(event: Event) async throws -> Event {
        var newEvent = Event(id: index,
                             tripId: event.tripId,
                             title: event.title,
                             details: event.details,
                             status: event.status,
                             datetime: event.datetime,
                             meetingPoint: event.meetingPoint,
                             location: event.location,
                             hostUser: event.hostUser,
                             invitedUsers: event.invitedUsers,
                             attendingUsers: event.attendingUsers + [event.hostUser],
                             rejectedUsers: event.rejectedUsers)
        index += 1
        return newEvent
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
