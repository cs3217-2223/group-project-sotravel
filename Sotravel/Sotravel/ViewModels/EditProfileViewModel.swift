//
//  EditProfileViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 20/3/23.
//
import Foundation

class EditProfileViewModel: UserObserver, ObservableObject {
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var description: String?
    @Published var instagramUsername: String?
    @Published var tiktokUsername: String?

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

    init(user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.description = user.description
        self.instagramUsername = user.instagramUsername
        self.tiktokUsername = user.tiktokUsername
    }

    override func updateFrom(data: User) {
        DispatchQueue.main.async {
            self.firstName = data.firstName
            self.lastName = data.lastName
            self.description = data.desc
            self.instagramUsername = data.instagramUsername
            self.tiktokUsername = data.tiktokUsername
        }
    }

    override func clear() {
        self.firstName = ""
        self.lastName = ""
        self.description = ""
        self.instagramUsername = ""
        self.tiktokUsername = ""
    }
}
