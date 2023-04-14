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

    @Injected private var eventRepository: EventRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.observers = [:]
        super.init()
    }

    func getEventViewModel(eventId: Int) -> EventViewModel? {
        guard let event = get(id: eventId), let observer = observers[event]?.first else {
            return nil
        }
        return observer as? EventViewModel
    }

    func getEventViewModels() -> [EventViewModel] {
        let allObservers = observers.values.flatMap { $0 }
        let eventViewModels = allObservers.compactMap { $0 as? EventViewModel }
        return eventViewModels
    }

    func loadUserEvents(forTrip tripId: Int, userId: UUID) {
        Task {
            do {
                let allEvents = try await eventRepository.getUserEvents(userId: userId, tripId: tripId)
                let events = allEvents.filter { $0.status != "cancelled" }
                DispatchQueue.main.async {
                    self.initCache(from: events)
                    self.createEventViewModels(from: events)
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
                    self.addObserver(viewModel, for: newEvent)
                    completion(.success(newEvent))
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(.failure(error))
            }
        }
    }

    func cancelEvent(id: Int, completion: @escaping (Bool) -> Void) {
        guard let event = get(id: id) else {
            return
        }
        Task {
            do {
                try await eventRepository.cancelEvent(id: id)
                DispatchQueue.main.async {
                    super.remove(item: id)
                    self.removeAllObservers(for: event)
                    completion(true)
                }
            } catch {
                serviceErrorHandler.handle(error)
                completion(false)
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
        let eventViewModels = attendingEvents.compactMap { event in
            observers[event]?.first as? EventViewModel
        }
        return eventViewModels
    }

    func clear() {
        super.clearCache()
        self.observers = [:]
    }

    private func updateCacheAndViewModels(from events: [Event]) {
        for event in events {
            if get(id: event.id) == nil {
                let viewModel = EventViewModel(event: event)
                self.addObserver(viewModel, for: event)
            } else {
                self.notifyAll(for: event)
            }
            updateCache(from: event)
        }
    }

    private func createEventViewModels(from events: [Event]) {
        for event in events {
            let viewModel = EventViewModel(event: event)
            self.addObserver(viewModel, for: event)
        }
    }
}
