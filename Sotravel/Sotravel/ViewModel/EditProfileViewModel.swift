//
//  EditProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 20/3/23.
//

struct EditProfileViewModel {
    private(set) var name: String
    private(set) var description: String
    private(set) var instagramUsername: String
    private(set) var tiktokUsername: String

    init(name: String = "", description: String = "", instagramUsername: String = "", tiktokUsername: String = "") {
        self.name = name
        self.description = description
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
    }

    mutating func updateFrom(user: User) {
        self.name = user.name
        self.description = user.description
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
    }
}
