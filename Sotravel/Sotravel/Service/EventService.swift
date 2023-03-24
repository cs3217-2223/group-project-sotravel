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
    @Published var events: [Event]
    private var eventToViewModels: [Event: [EventServiceViewModel]]

    //    @Injected private var eventRepository: EventRepository

    private var cancellables: Set<AnyCancellable> = []

    init(events: [Event] = mockEvents) {
        self.events = events
        self.eventToViewModels = [:]
        for event in events {
            eventToViewModels[event] = [EventViewModel(event: event)]
        }

        setupObservers()
    }

    func fetchEvent(id: UUID) {
        // setupObservers()
    }

    func updateEvent() {

    }

    func findAttendingEvents(for user: User) -> [Event] {
        events.filter { $0.attendingUsers.contains(user) }
    }

    private func setupObservers() {
        for event in events {
            event.objectWillChange.sink { [weak self] _ in
                self?.handleEventPropertyChange(for: event)
            }.store(in: &cancellables)
        }
    }

    private func updateUserObservers() {
        cancellables.removeAll()
        setupObservers()
    }

    private func handleEventPropertyChange(for event: Event) {
        guard let viewModels = eventToViewModels[event] else { return }
        for viewModel in viewModels {

        }
    }
}
