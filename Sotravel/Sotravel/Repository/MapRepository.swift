import Foundation
import CoreLocation

protocol MapRepository {
    func listenForFriendsLocations(completion: @escaping ([String: CLLocation]) -> Void)
    func updateCurrentUserLocation(_ location: CLLocation, userId: String)
}
