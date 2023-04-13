//
//  EventService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 22/3/23.
//

import Foundation
import Resolver
import Combine

class EventService: BaseCacheService<Event>, ObservableObject, Subject {
    typealias ObservedData = Event
    typealias ObserverProtocol = EventObserver

    internal var observers: [ObservedData: [ObserverProtocol]]

    @Published var eventViewModels: [EventViewModel]
    private var eventToViewModels: [Event: EventViewModel]

    @Injected private var eventRepository: EventRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.eventViewModels = []
        self.eventToViewModels = [:]
        self.observers = [:]
        super.init()
    }

    func getEventViewModel(eventId: Int) -> EventViewModel? {
        guard let event = get(id: eventId) else {
            return nil
        }
        return eventToViewModels[event]
    }

    func loadUserEvents(forTrip tripId: Int, userId: UUID) {
        Task {
            do {
                let allEvents = try await eventRepository.getUserEvents(userId: userId, tripId: tripId)
                let events = allEvents.filter { $0.status != "cancelled" }
                DispatchQueue.main.async {
                    self.initCache(from: events)
                    self.createEventViewModels(from: events)
                    self.objectWillChange.send()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func reloadUserEvents(forTrip tripId: Int, userId: UUID) {
        Task {
            do {
                let allEvents = try await eventRepository.getUserEvents(userId: userId, tripId: tripId)
                let events = allEvents.filter { $0.status != "cancelled" }
                DispatchQueue.main.async {
                    self.updateCacheAndViewModels(from: events)
                    self.objectWillChange.send()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func createEvent(event: Event, completion: @escaping (Result<Event, Error>) -> Void) {
        Task {
            do {
                let newEvent = try await eventRepository.create(event: event)
                DispatchQueue.main.async {
                    super.updateCache(from: newEvent)
                    let viewModel = EventViewModel(event: newEvent)
                    self.eventViewModels.append(viewModel)
                    self.eventToViewModels[newEvent] = viewModel
                    completion(.success(newEvent))
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(.failure(error))
            }
        }
    }

    func cancelEvent(id: Int) {
        Task {
            do {
                try await eventRepository.cancelEvent(id: id)
                DispatchQueue.main.async {
                    super.remove(item: id)
                    self.eventViewModels.removeAll { $0.id == id }
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func rsvpToEvent(eventId: Int, userId: UUID, status: EventRsvpStatus) {
        Task {
            do {
                try await eventRepository.rsvpToEvent(eventId: eventId, userId: userId, status: status)

                guard let event = get(id: eventId) else {
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

                self.notifyAll(for: event)
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func findAttendingEventsId(for user: User) -> [Int] {
        let attendingEvents = super.getAll().filter { event in
            event.attendingUsers.contains(user.id) || event.hostUser == user.id
        }
        return attendingEvents.map { $0.id }
    }

    func findAttendingEventsVM(for user: User) -> [EventViewModel] {
        let attendingEvents = super.getAll().filter { event in
            event.attendingUsers.contains(user.id) || event.hostUser == user.id
        }
        return attendingEvents.compactMap { eventToViewModels[$0] }
    }

    func clear() {
        super.clearCache()
        self.eventToViewModels = [:]
        self.eventViewModels = []
        self.observers = [:]
    }

    private func updateCacheAndViewModels(from events: [Event]) {
        for event in events where get(id: event.id) == nil {
            updateCache(from: event)
            let viewModel = EventViewModel(event: event)
            self.eventViewModels.append(viewModel)
            self.eventToViewModels[event] = viewModel
            self.addObserver(viewModel, for: event)
        }
    }

    private func createEventViewModels(from events: [Event]) {
        for event in events {
            let viewModel = EventViewModel(event: event)
            self.eventViewModels.append(viewModel)
            self.eventToViewModels[event] = viewModel
            self.addObserver(viewModel, for: event)
        }
    }
}
