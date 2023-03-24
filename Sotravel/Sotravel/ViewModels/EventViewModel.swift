//
//  EventViiewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

struct EventViewModel: EventServiceViewModel {
    var attendingUsers: [User]
    var datetime: Date
    var location: String

    init(attendingUsers: [User] = [], datetime: Date = Date(), location: String = "") {
        self.attendingUsers = attendingUsers
        self.datetime = datetime
        self.location = location
    }

    init(event: Event) {
        self.attendingUsers = event.attendingUsers
        self.datetime = event.datetime
        self.location = event.location
    }

    mutating func updateFrom(event: Event) {
        self.attendingUsers = event.attendingUsers
        self.datetime = event.datetime
        self.location = event.location
    }
}
