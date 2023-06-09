//
//  UserDefault.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 2/4/23.
//

import Foundation

extension UserDefaults {
    func resetLogin() {
        removeObject(forKey: "LoggedIn")
    }

    func resetLastSelectedTrip() {
        removeObject(forKey: "LastSelectedTripId")
    }

    func resetApiKey() {
        removeObject(forKey: "nodeApiBearerToken")
    }
}
