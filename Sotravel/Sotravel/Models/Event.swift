import Foundation

class Event: Hashable, Identifiable {
    var id: UUID
    var title: String
    var details: String?
    var status: String
    var datetime: Date
    var meetingPoint: String
    var location: String
    var hostUser: User
    var invitedUsers: [User]
    var attendingUsers: [User]
    var rejectedUsers: [User]

    var description: String {
        "\(title) at \(location)"
    }

    init(id: UUID = UUID(),
         title: String,
         details: String?,
         status: String,
         datetime: Date,
         meetingPoint: String,
         location: String,
         hostUser: User,
         invitedUsers: [User] = [],
         attendingUsers: [User] = [],
         rejectedUsers: [User] = []) {
        self.id = id
        self.title = title
        self.details = details
        self.status = status
        self.datetime = datetime
        self.meetingPoint = meetingPoint
        self.location = location
        self.hostUser = hostUser
        self.invitedUsers = invitedUsers
        self.attendingUsers = attendingUsers
        self.rejectedUsers = rejectedUsers
    }

    var pendingUsers: [User] {
        let respondedUsers = attendingUsers + rejectedUsers
        return invitedUsers.filter { !respondedUsers.contains($0) }
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
