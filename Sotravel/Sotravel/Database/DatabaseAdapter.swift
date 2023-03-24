//
//  DatabaseAdapter.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 19/3/23.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class DatabaseAdapter: DatabaseConnector, MapRepository {
    private let databaseRef = Database.database().reference()
    private let encoder = JSONEncoder()

    func sendChatMessage(chatMessage: ChatMessage, chat: Chat) -> Bool {
        let databasePath = databaseRef.child("messages/\(chat.id)")
        do {
            let data = try encoder.encode(chatMessage)
            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.child(chatMessage.id.uuidString).setValue(json)
        } catch {
            print("An error occurred", error)
            return false
        }
        return true
    }

    func listenForFriendsLocations(completion: @escaping ([String: CLLocation]) -> Void) {
        databaseRef.child("locations").observe(.value, with: { snapshot in
            var newLocations: [String: CLLocation] = [:]

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let locationData = childSnapshot.value as? [String: Any],
                   let latitude = locationData["latitude"] as? CLLocationDegrees,
                   let longitude = locationData["longitude"] as? CLLocationDegrees {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    newLocations[childSnapshot.key] = location
                }
            }

            completion(newLocations)
        })
    }

    func updateCurrentUserLocation(_ location: CLLocation, userId: String) {
        let userData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        databaseRef.child("locations/\(userId)").setValue(userData)
    }
}
