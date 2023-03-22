//
//  EventService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 22/3/23.
//

import SwiftUI
import Resolver

class EventService: ObservableObject {
    @Published var events: [Event]

    @Injected private var eventRepository: EventRepository

    init(events: [Event] = mockEvents) {
        self.events = events
    }

    func findAttendingEvents(for user: User) -> [Event] {
        events.filter { $0.attendingUsers.contains(user) }
    }
}
