import Foundation
import CoreLocation

class FriendsLocationViewModel: ObservableObject {
    @Published var friendsLocations: [String: CLLocation] = [:]
    private var databaseAdapter: MapRepository = DatabaseAdapter()

    init() {
        listenForFriendsLocations()
    }

    private func listenForFriendsLocations() {
        databaseAdapter.listenForFriendsLocations { [weak self] newLocations in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.friendsLocations = newLocations
            }
        }
    }

    func updateCurrentUserLocation(_ location: CLLocation, userId: String) {
        databaseAdapter.updateCurrentUserLocation(location, userId: userId)
    }
}
