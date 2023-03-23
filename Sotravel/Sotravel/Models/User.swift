import Foundation

class User: Identifiable, Hashable {
    var id = UUID()
    var firstName: String?
    var lastName: String?
    var description: String? // Optional
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
            return (firstName ?? "") + (firstName ?? "")
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
        self.description = description
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
        self.description = apiUser.description
        self.imageURL = apiUser.image
        self.instagramUsername = apiUser.socialsInstagram
        self.tiktokUsername = apiUser.socialsTiktok
        self.telegramUsername = apiUser.teleUsername
        // API user does not have friends
        self.friends = []
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
