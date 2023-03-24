//
//  EventViiewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

class EventViewModel: EventServiceViewModel, ObservableObject {
    @Published var invitedUsers: [User]
    @Published var attendingUsers: [User]
    @Published var rejectedUsers: [User]
    @Published var datetime: Date
    @Published var meetingPoint: String
    @Published var location: String
    @Published var activity: String
    @Published var description: String

    var id: UUID
    var title: String {
        "\(self.activity) at \(self.location)"
    }
    var pendingUsers: [User] {
        let respondedUsers = attendingUsers + rejectedUsers
        return invitedUsers.filter { !respondedUsers.contains($0) }
    }

    init(id: UUID = UUID(),
         activity: String = "",
         invitedUsers: [User] = [],
         attendingUsers: [User] = [],
         rejectedUsers: [User] = [],
         datetime: Date = Date(),
         location: String = "",
         meetingPoint: String = "",
         description: String = "") {
        self.id = id
        self.activity = activity
        self.invitedUsers = invitedUsers
        self.attendingUsers = attendingUsers
        self.rejectedUsers = rejectedUsers
        self.datetime = datetime
        self.location = location
        self.description = description
        self.meetingPoint = meetingPoint
    }

    init(event: Event) {
        self.id = event.id
        self.activity = event.activity
        self.invitedUsers = event.invitedUsers
        self.attendingUsers = event.attendingUsers
        self.rejectedUsers = event.rejectedUsers
        self.datetime = event.datetime
        self.location = event.location
        self.description = event.description
        self.meetingPoint = event.meetingPoint
    }

    func updateFrom(event: Event) {
        self.id = event.id
        self.activity = event.activity
        self.invitedUsers = event.invitedUsers
        self.attendingUsers = event.attendingUsers
        self.rejectedUsers = event.rejectedUsers
        self.datetime = event.datetime
        self.location = event.location
        self.description = event.description
        self.meetingPoint = event.meetingPoint
    }
}
