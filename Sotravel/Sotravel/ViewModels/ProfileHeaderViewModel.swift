//
//  ProfileHeaderViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class ProfileHeaderViewModel: ObservableObject {
    @Published var name: String?
    @Published var description: String?
    @Published var imageURL: String?

    init(name: String = "", description: String = "", imageURL: String = "") {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }

    func updateFrom(user: User) {
        DispatchQueue.main.async {
            self.name = user.name
            self.description = user.desc
            self.imageURL = user.imageURL
        }
    }

    func clear() {
        self.name = ""
        self.description = ""
        self.imageURL = ""
    }
}
