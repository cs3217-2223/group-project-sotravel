import Foundation
import CoreLocation
import Firebase

class FriendsLocationViewModel: ObservableObject {
    @Published var friendsLocations: [String: CLLocation] = [:]
    private var db = Database.database().reference()

    init() {
        listenForFriendsLocations()
    }

    private func listenForFriendsLocations() {
        db.child("locations").observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
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

            DispatchQueue.main.async {
                self.friendsLocations = newLocations
            }
        })
    }

    func updateCurrentUserLocation(_ location: CLLocation, userId: String) {
        let userData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        db.child("locations/\(userId)").setValue(userData)
    }
}
