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
    @Published var eventCache: [Int: Event]
    @Published var eventToViewModels: [Event: EventViewModel]

    @Injected private var eventRepository: EventRepository

    init() {
        self.eventViewModels = []
        self.eventToViewModels = [:]
        self.eventCache = [:]
    }

    func getEvent(id: Int) throws -> Event {
        mockEvent1
    }

    func loadUserEvents(forTrip tripId: Int, userId: UUID) {
        Task {
            do {
                let events = try await eventRepository.getUserEvents(userId: userId, tripId: tripId)
                DispatchQueue.main.async {
                    self.initCache(from: events)
                    self.createEventViewModels(from: events)
                    self.objectWillChange.send()
                }
            } catch {
                print("Error loading user events:", error)
            }
        }
    }

    func createEvent(event: Event, completion: @escaping (Result<Event, Error>) -> Void) {
        Task {
            do {
                let newEvent = try await eventRepository.create(event: event)
                DispatchQueue.main.async {
                    self.eventCache[newEvent.id] = newEvent
                    let viewModel = EventViewModel(event: newEvent)
                    self.eventViewModels.append(viewModel)
                    self.eventToViewModels[newEvent] = viewModel
                    completion(.success(newEvent))
                }
            } catch {
                print("Error creating event:", error)
                completion(.failure(error))
            }
        }
    }

    func cancelEvent(id: Int) {
        Task {
            do {
                try await eventRepository.cancelEvent(id: id)
                DispatchQueue.main.async {
                    self.eventCache[id] = nil
                    self.eventViewModels.removeAll { $0.id == id }
                }
            } catch {
                print("Error canceling event:", error)
            }
        }
    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) {
        Task {
            do {
                try await eventRepository.rsvpToEvent(eventId: eventId, userId: userId, status: status)

                guard let event = eventCache[eventId] else {
                    print("Error: Event for RSVP not found")
                    return
                }

                event.attendingUsers.removeAll { $0 == userId }
                event.rejectedUsers.removeAll { $0 == userId }

                switch status {
                case .yes:
                    event.attendingUsers.append(userId)
                case .no:
                    event.rejectedUsers.append(userId)
                }

                self.handleEventPropertyChange(for: event)
            } catch {
                print("Error RSVPing to event:", error)
            }
        }
    }

    func fetchEventIfNeededFrom(id: Int) async {
        if eventCache[id] == nil {
            do {
                let fetchedEvent = try await eventRepository.get(id: id)
                DispatchQueue.main.async {
                    self.eventCache[id] = fetchedEvent
                    let viewModel = EventViewModel(event: fetchedEvent)
                    self.eventViewModels.append(viewModel)
                    self.eventToViewModels[fetchedEvent] = viewModel
                    self.objectWillChange.send()
                }
            } catch {
                print("Error fetching event:", error)
            }
        }
    }

    func findAttendingEvents(for user: User) -> [EventViewModel] {
        let attendingEvents = eventCache.values.filter { event in
            event.attendingUsers.contains(user.id) || event.hostUser == user.id
        }
        return attendingEvents.compactMap { eventToViewModels[$0] }
    }

    func clear() {
        self.eventCache = [:]
        self.eventToViewModels = [:]
        self.eventViewModels = []
    }

    private func createEventViewModels(from events: [Event]) {
        for event in events {
            let viewModel = EventViewModel(event: event)
            self.eventViewModels.append(viewModel)
            self.eventToViewModels[event] = viewModel
        }
    }

    private func initCache(from events: [Event]) {
        for event in events {
            self.eventCache[event.id] = event
        }
    }

    private func handleEventPropertyChange(for event: Event) {
        guard let viewModel = eventToViewModels[event] else {
            return
        }
        viewModel.updateFrom(event: event)
    }
}
