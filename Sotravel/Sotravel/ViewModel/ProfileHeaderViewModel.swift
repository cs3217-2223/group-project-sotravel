//
//  ProfileHeaderViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//

struct ProfileHeaderViewModel {
    var name: String?
    var description: String?
    var imageURL: String?

    init(name: String = "", description: String = "", imageURL: String = "") {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }

    mutating func updateFrom(user: User) {
        self.name = user.name
        self.description = user.description
        self.imageURL = user.imageURL
    }
}
