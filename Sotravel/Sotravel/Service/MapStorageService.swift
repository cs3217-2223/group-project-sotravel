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

    private func fetchFriendsLocations() {
        mapRepository.listenForFriendsLocations { [weak self] locations in
            DispatchQueue.main.async {
                self?.friendsLocations = locations
            }
        }
    }

    func updateCurrentUserLocation(_ location: CLLocation, userId: String) {
        mapRepository.updateCurrentUserLocation(location, userId: userId)
    }

    func removeCurrentUserLocation(userId: String) {
        mapRepository.removeCurrentUserLocation(userId: userId)
    }
}
