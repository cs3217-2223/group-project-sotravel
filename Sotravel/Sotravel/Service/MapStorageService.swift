import Foundation
import Combine
import CoreLocation

class MapStorageService: ObservableObject {
    @Published var friendsLocations: [String: CLLocation] = [:]

    private var cancellables = Set<AnyCancellable>()
    private let mapRepository: MapRepository

    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
        fetchFriendsLocations()
    }

    func startUserLocationUpdate(locationManager: LocationManagerService, userId: String) {
        locationManager.locationUpdateHandler = {
            location in
            self.mapRepository.updateCurrentUserLocation(location, userId: userId)
        }
    }

    func stopUserLocationUpdate(locationManager: LocationManagerService, userId: String) {
        locationManager.locationUpdateHandler = nil
        mapRepository.removeCurrentUserLocation(userId: userId)
    }

    private func fetchFriendsLocations() {
        mapRepository.listenForFriendsLocations { [weak self] locations in
            DispatchQueue.main.async {
                self?.friendsLocations = locations
            }
        }
    }
}
