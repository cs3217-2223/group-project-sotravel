import SwiftUI

class EventsStore: ObservableObject {
    @Published var events: [Event]

    init(events: [Event]) {
        self.events = events
    }

    func findAttendingEvents(for user: User) -> [Event] {
        events.filter { $0.attendingUsers.contains(user) }
    }
}
