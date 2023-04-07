import Foundation

class Event: Hashable, Identifiable, ConvertableFromApiModel {
    var id: Int
    var tripId: Int
    var title: String
    var details: String?
    var status: String?
    var datetime: Date
    var meetingPoint: String
    var location: String
    var hostUser: UUID
    var invitedUsers: [UUID]
    var attendingUsers: [UUID]
    var rejectedUsers: [UUID]

    var description: String {
        "\(title) at \(location)"
    }

    init(id: Int = -1,
         tripId: Int,
         title: String,
         details: String?,
         status: String?,
         datetime: Date,
         meetingPoint: String,
         location: String,
         hostUser: UUID,
         invitedUsers: [UUID] = [],
         attendingUsers: [UUID] = [],
         rejectedUsers: [UUID] = []) {
        self.id = id
        self.tripId = tripId
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

    required init(apiModel: EventApiModel) {
        self.id = apiModel.id
        self.tripId = apiModel.tripId
        self.title = apiModel.activity
        // TODO: Don't do this
        self.hostUser = UUID(uuidString: apiModel.host) ?? UUID()
        self.status = apiModel.status
        self.details = apiModel.details

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let dateTimeStr = "\(apiModel.date) \(apiModel.time)"
        self.datetime = dateFormatter.date(from: dateTimeStr) ?? Date()

        self.location = apiModel.location
        self.meetingPoint = apiModel.meetingPoint
        // Map UUID strings to UUID, if its nil compactmap will ignore the value
        self.invitedUsers = apiModel.participants.pending.compactMap { UUID(uuidString: $0) }
        self.attendingUsers = apiModel.participants.going.compactMap { UUID(uuidString: $0) }
        self.rejectedUsers = apiModel.participants.no.compactMap { UUID(uuidString: $0) }
    }

    var pendingUsers: [UUID] {
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
