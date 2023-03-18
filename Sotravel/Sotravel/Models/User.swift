import Foundation

class User: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String // Optional
    var imageURL: String // Optional
    var instagramUsername: String // Optional
    var tiktokUsername: String // Optional
    var telegramUsername: String
    var friends: [User]

    init(
        name: String = "",
        description: String = "",
        imageURL: String = "",
        instagramUsername: String = "",
        tiktokUsername: String = "",
        telegramUsername: String = "",
        friends: [User] = []
    ) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
        self.friends = friends
    }

    init(apiUser: NodeApiUser) {
        self.name = (apiUser.firstName ?? "") + (apiUser.lastName ?? "")
        self.description = apiUser.description ?? ""
        self.imageURL = apiUser.image ?? ""
        self.instagramUsername = apiUser.socialsInstagram ?? ""
        self.tiktokUsername = apiUser.socialsTiktok ?? ""
        self.telegramUsername = apiUser.teleUsername ?? ""
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
