//
//  EditProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 20/3/23.
//

struct EditProfileViewModel {
    var firstName: String?
    var lastName: String?
    var description: String?
    var instagramUsername: String?
    var tiktokUsername: String?
    var name: String? {
        if firstName == nil && firstName == nil {
            return nil
        } else {
            return (firstName ?? "") + (firstName ?? "")
        }
    }

    init(firstName: String = "",
         lastName: String = "",
         description: String = "",
         instagramUsername: String = "",
         tiktokUsername: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.description = description
        self.instagramUsername = instagramUsername
        self.tiktokUsername = tiktokUsername
    }

    mutating func updateFrom(user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.description = user.description
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
    }
}
