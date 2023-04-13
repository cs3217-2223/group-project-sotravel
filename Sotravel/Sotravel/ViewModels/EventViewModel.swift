//
//  EventViiewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//

import Foundation

class EventViewModel: EventObserver, ObservableObject {
    var id: Int
    @Published var title: String
    @Published var details: String?
    @Published var datetime: Date
    @Published var meetingPoint: String
    @Published var location: String
    @Published var invitedUsers: [UUID]
    @Published var attendingUsers: [UUID]
    @Published var rejectedUsers: [UUID]
    @Published var hostUser: UUID
    @Published var eventStatus: EventStatus

    var description: String {
        "\(title) at \(location)"
    }

    var pendingUsers: [UUID] {
        let respondedUsers = attendingUsers + rejectedUsers
        return invitedUsers.filter { !respondedUsers.contains($0) }
    }

    init(id: Int = -1,
         title: String = "",
         details: String? = nil,
         datetime: Date = Date(),
         location: String = "",
         meetingPoint: String = "",
         invitedUsers: [UUID] = [],
         attendingUsers: [UUID] = [],
         rejectedUsers: [UUID] = [],
         hostUser: UUID = UUID(),
         eventStatus: EventStatus = .pending) {
        self.id = id
        self.title = title
        self.details = details
        self.datetime = datetime
        self.location = location
        self.meetingPoint = meetingPoint
        self.invitedUsers = invitedUsers
        self.attendingUsers = attendingUsers
        self.rejectedUsers = rejectedUsers
        self.hostUser = hostUser
        self.eventStatus = eventStatus
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
        self.hostUser = event.hostUser
        self.eventStatus = EventStatus.pending
    }

    override func updateFrom(data: Event) {
        DispatchQueue.main.async {
            self.id = data.id
            self.title = data.title
            self.datetime = data.datetime
            self.location = data.location
            self.details = data.details
            self.meetingPoint = data.meetingPoint
            self.invitedUsers = data.invitedUsers
            self.attendingUsers = data.attendingUsers
            self.rejectedUsers = data.rejectedUsers
            self.hostUser = data.hostUser
        }
    }

    override func clear() {
        self.id = .zero
        self.title = ""
        self.datetime = Date()
        self.location = ""
        self.details = ""
        self.meetingPoint = ""
        self.invitedUsers = []
        self.attendingUsers = []
        self.rejectedUsers = []
        self.hostUser = UUID()
        self.eventStatus = EventStatus.pending
    }

    func updateEventStatus(userId: UUID) {
        if self.attendingUsers.contains(userId)
            || self.hostUser == userId {
            self.eventStatus = .going
        } else if self.rejectedUsers.contains(userId) {
            self.eventStatus = .notGoing
        } else {
            self.eventStatus = .pending
        }

    }
}
