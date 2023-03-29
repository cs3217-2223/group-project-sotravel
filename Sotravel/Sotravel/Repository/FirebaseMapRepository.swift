import Foundation
import CoreLocation
import FirebaseDatabase

class FirebaseMapRepository: MapRepository {
    private let databaseRef = Database.database().reference()

    func listenForFriendsLocations(completion: @escaping ([String: CLLocation]) -> Void) {
        let friendsLocationsRef = databaseRef.child("locations")

        friendsLocationsRef.observe(.value) { snapshot in
            var locations: [String: CLLocation] = [:]

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let locationData = childSnapshot.value as? [String: Any],
                   let latitude = locationData["latitude"] as? CLLocationDegrees,
                   let longitude = locationData["longitude"] as? CLLocationDegrees {

                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    locations[childSnapshot.key] = location
                }
            }

            print("LOCATIONS: ", locations)

            completion(locations)
        }
    }

    func updateCurrentUserLocation(_ location: CLLocation, userId: String) {
        let userLocationRef = databaseRef.child("locations/\(userId)")

        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]

        userLocationRef.setValue(locationData)
    }

    func removeCurrentUserLocation(userId: String) {
        let userLocationRef = databaseRef.child("locations/\(userId)")
        userLocationRef.removeValue()
    }
}
