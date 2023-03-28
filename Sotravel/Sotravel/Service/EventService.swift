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

    @Injected private var eventRepository: EventRepository

    init() {
        self.events = []
        self.eventViewModels = []
        self.eventToViewModels = [:]
    }

    func loadUserEvents(forTrip tripId: Int) {
        let userId = mockUser.id // Replace this with the actual user ID
        Task {
            do {
                let events = try await eventRepository.getUserEvents(userId: userId, tripId: tripId)
                DispatchQueue.main.async {
                    self.events = events
                    self.createEventViewModels(from: events)
                    self.objectWillChange.send()
                }
            } catch {
                print("Error loading user events:", error)
            }
        }
    }

    //    func getEvent(id: Int) {
    //        Task {
    //            do {
    //                let event = try await eventRepository.get(id: id)
    //                DispatchQueue.main.async {
    //                    self.handleEventPropertyChange(for: event)
    //                }
    //            } catch {
    //                print("Error getting event:", error)
    //            }
    //        }
    //    }

    func createEvent(event: Event) {
        Task {
            do {
                let newEvent = try await eventRepository.create(event: event)
                DispatchQueue.main.async {
                    self.events.append(newEvent)
                    let viewModel = EventViewModel(event: event)
                    self.eventViewModels.append(viewModel)
                    self.eventToViewModels[event] = viewModel
                }
            } catch {
                print("Error creating event:", error)
            }
        }
    }

    func cancelEvent(id: Int) {
        Task {
            do {
                try await eventRepository.cancelEvent(id: id)
                DispatchQueue.main.async {
                    self.events.removeAll { $0.id == id }
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

                guard let eventIndex = events.firstIndex(where: { $0.id == eventId }) else {
                    print("Error: Event for RSVP not found")
                    return
                }

                let event = events[eventIndex]

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

    func findAttendingEvents(for user: User) -> [EventViewModel] {
        let attendingEvents = events.filter { event in
            event.attendingUsers.contains(user.id) || event.hostUser == user.id
        }
        return attendingEvents.compactMap { eventToViewModels[$0] }
    }

    private func createEventViewModels(from events: [Event]) {
        for event in events {
            let viewModel = EventViewModel(event: event)
            self.eventViewModels.append(viewModel)
            self.eventToViewModels[event] = viewModel
        }
    }

    private func handleEventPropertyChange(for event: Event) {
        guard let viewModel = eventToViewModels[event] else {
            return
        }
        viewModel.updateFrom(event: event)
    }

    private func handleEventsPropertyChange() {
        for event in events {
            let viewModel = eventToViewModels[event]
            viewModel?.updateFrom(event: event)
        }

    }
}
