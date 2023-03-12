import SwiftUI

class EventsStore: ObservableObject {
    @Published var events: [Event]

    init(events: [Event]) {
        self.events = events
    }
}
