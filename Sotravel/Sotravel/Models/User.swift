import Foundation

class User: Identifiable, Hashable, ConvertableFromApiModel {

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
        if firstName == nil && lastName == nil {
            return nil
        } else {
            return (firstName ?? "") + " " + (lastName ?? "")
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

    required init(apiModel: NodeApiUser) throws {
        guard let id = UUID(uuidString: apiModel.id) else {
            throw SotravelError.DecodingError("Unable to get id from apiUser")
        }
        self.id = id
        self.firstName = apiModel.firstName
        self.lastName = apiModel.lastName
        self.email = apiModel.email
        self.desc = apiModel.description
        self.imageURL = apiModel.image
        self.instagramUsername = apiModel.socialsInstagram
        self.tiktokUsername = apiModel.socialsTiktok
        self.telegramUsername = apiModel.teleUsername
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
