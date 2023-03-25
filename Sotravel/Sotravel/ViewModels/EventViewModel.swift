//
//  EventViiewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

class EventViewModel: ObservableObject {
    var id: UUID
    @Published var title: String
    @Published var details: String?
    @Published var datetime: Date
    @Published var meetingPoint: String
    @Published var location: String
    @Published var invitedUsers: [User]
    @Published var attendingUsers: [User]
    @Published var rejectedUsers: [User]

    var description: String {
        "\(title) at \(location)"
    }

    var pendingUsers: [User] {
        let respondedUsers = attendingUsers + rejectedUsers
        return invitedUsers.filter { !respondedUsers.contains($0) }
    }

    init(id: UUID = UUID(),
         title: String,
         details: String? = nil,
         datetime: Date,
         location: String,
         meetingPoint: String,
         invitedUsers: [User] = [],
         attendingUsers: [User] = [],
         rejectedUsers: [User] = []) {
        self.id = id
        self.title = title
        self.details = details
        self.datetime = datetime
        self.location = location
        self.meetingPoint = meetingPoint
        self.invitedUsers = invitedUsers
        self.attendingUsers = attendingUsers
        self.rejectedUsers = rejectedUsers
    }

    init(event: Event) {
        self.id = event.id
        self.title = event.title
        self.invitedUsers = event.invitedUsers
        self.attendingUsers = event.attendingUsers
        self.rejectedUsers = event.rejectedUsers
        self.datetime = event.datetime
        self.location = event.location
        self.details = event.details
        self.meetingPoint = event.meetingPoint
    }

    func updateFrom(event: Event) {
        DispatchQueue.main.async {
            self.id = event.id
            self.title = event.title
            self.datetime = event.datetime
            self.location = event.location
            self.details = event.details
            self.meetingPoint = event.meetingPoint
            self.invitedUsers = event.invitedUsers
            self.attendingUsers = event.attendingUsers
            self.rejectedUsers = event.rejectedUsers
        }
    }
}
