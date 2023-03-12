import SwiftUI

class Event: ObservableObject, Hashable, Identifiable {
    @Published var invitedUsers: [User]
    @Published var attendingUsers: [User]
    @Published var rejectedUsers: [User]
    @Published var datetime: Date
    @Published var meetingPoint: String
    @Published var location: String
    @Published var title: String
    @Published var description: String
    @Published var hostUser: User

    var id: UUID

    init(id: UUID = UUID(),
         title: String = "",
         invitedUsers: [User] = [],
         attendingUsers: [User] = [],
         rejectedUsers: [User] = [],
         datetime: Date = Date(),
         location: String = "",
         meetingPoint: String = "",
         description: String = "",
         hostUser: User) {
        self.id = id
        self.title = title
        self.invitedUsers = invitedUsers
        self.attendingUsers = attendingUsers
        self.rejectedUsers = rejectedUsers
        self.datetime = datetime
        self.location = location
        self.description = description
        self.hostUser = hostUser
        self.meetingPoint = meetingPoint
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
