//
//  ProfileHeaderViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 19/3/23.
//
import Foundation

class ProfileHeaderViewModel: UserObserver, ObservableObject {
    @Published var name: String?
    @Published var description: String?
    @Published var imageURL: String?

    init(name: String = "", description: String = "", imageURL: String = "") {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }

    override func updateFrom(data: User) {
        DispatchQueue.main.async {
            self.name = data.name
            self.description = data.desc
            self.imageURL = data.imageURL
        }
    }

    override func clear() {
        self.name = ""
        self.description = ""
        self.imageURL = ""
    }
}
