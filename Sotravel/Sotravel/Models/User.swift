import SwiftUI

class User: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var imageURL: String
    @Published var instagramUsername: String
    @Published var tiktokUsername: String
    @Published var telegramUsername: String
    @Published var friends: [User]

    init(name: String, description: String, imageURL: String, instagramUsername: String, tiktokUsername: String, telegramUsername: String, friends: [User]) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
        self.telegramUsername = telegramUsername
        self.friends = friends
    }
}
