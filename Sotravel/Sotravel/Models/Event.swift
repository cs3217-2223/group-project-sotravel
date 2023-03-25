import SwiftUI

class Event: ObservableObject, Hashable, Identifiable {
    var id: UUID
    @Published var title: String
    @Published var details: String?
    @Published var status: String
    @Published var datetime: Date
    @Published var meetingPoint: String
    @Published var location: String
    @Published var hostUser: User
    @Published var invitedUsers: [User]
    @Published var attendingUsers: [User]
    @Published var rejectedUsers: [User]

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
