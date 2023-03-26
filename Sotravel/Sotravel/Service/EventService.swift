//
//  EventService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 22/3/23.
//

import Foundation
import Resolver
import Combine

class EventService: ObservableObject {
    @Published var eventViewModels: [EventViewModel]

    private var events: [Event]
    private var eventToViewModels: [Event: EventViewModel]
    //    @Injected private var eventRepository: EventRepository

    init(events: [Event] = mockEvents) {
        self.events = events
        self.eventViewModels = []
        self.eventToViewModels = [:]

        // Initialize event view models and map each event to its view model
        for event in events {
            let viewModel = EventViewModel(event: event)
            self.eventViewModels.append(viewModel)
            self.eventToViewModels[event] = viewModel
        }
    }

    func findAttendingEvents(for user: User) -> [EventViewModel] {
        let attendingEvents = events.filter { $0.attendingUsers.contains(user.id) }
        return attendingEvents.compactMap { eventToViewModels[$0] }
    }

    private func handleEventPropertyChange(for event: Event) {
        guard let viewModel = eventToViewModels[event] else {
            return
        }
        viewModel.updateFrom(event: event)
    }
}
