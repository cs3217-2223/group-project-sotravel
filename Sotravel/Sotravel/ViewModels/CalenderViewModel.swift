//
//  CalenderViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 31/3/23.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var events: [Event]

    init(events: [Event] = []) {
        self.events = events
    }

    func updateFrom(events: [Event]) {
        self.events = events
    }

    func addEvent(event: Event) {
        self.events.append(event)
    }

    func removeEvent(id: Int) {
        self.events.removeAll { $0.id == id }
    }

    func clear() {
        self.events = []
    }
}
