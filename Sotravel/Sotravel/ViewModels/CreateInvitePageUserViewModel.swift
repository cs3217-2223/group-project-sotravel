//
//  CreateInvitePageViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 24/3/23.
//
import Foundation

class CreateInvitePageUserViewModel: ObservableObject {
    @Published var friends: [Friend]

    init(friends: [Friend] = []) {
        self.friends = friends
    }

    func updateFrom(friends: [Friend]) {
        DispatchQueue.main.async {
            self.friends = friends
        }
    }
}
