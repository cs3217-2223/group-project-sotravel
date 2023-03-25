import Foundation

class User: Identifiable, Hashable {
    var id = UUID()
    var firstName: String?
    var lastName: String?
    var desc: String? // Optional
    var imageURL: String? // Optional
    var instagramUsername: String? // Optional
    var tiktokUsername: String? // Optional
    var telegramUsername: String?
    var email: String?
    var friends: [User]
    var name: String? {
        if firstName == nil && firstName == nil {
            return nil
        } else {
            return (firstName ?? "") + (lastName ?? "")
        }
    }

    init(
        id: UUID,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        description: String? = nil,
        imageURL: String? = nil,
        instagramUsername: String? = nil,
        tiktokUsername: String? = nil,
        telegramUsername: String? = nil,
        friends: [User] = []
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.desc = description
        self.imageURL = imageURL
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
        self.friends = friends
    }

    init(apiUser: NodeApiUser) throws {
        guard let id = UUID(uuidString: apiUser.id) else {
            throw SotravelError.DecodingError("Unable to get id from apiUser")
        }
        self.id = id
        self.firstName = apiUser.firstName
        self.lastName = apiUser.lastName
        self.email = apiUser.email
        self.desc = apiUser.description
        self.imageURL = apiUser.image
        self.instagramUsername = apiUser.socialsInstagram
        self.tiktokUsername = apiUser.socialsTiktok
        self.telegramUsername = apiUser.teleUsername
        // API user does not have friends
        self.friends = []
    }

    func updateFirstName(_ firstName: String) {
        self.firstName = firstName
    }

    func updateLastName(_ lastName: String) {
        self.lastName = lastName
    }

    func updateDesc(_ desc: String) {
        self.desc = desc
    }

    func updateInstagramUsername(_ name: String) {
        self.instagramUsername = name
    }

    func updateTiktokUsername(_ name: String) {
        self.tiktokUsername = name
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var description: String { "User: \(self.id)" }
}
