import Foundation
import CoreLocation

class LocationManagerService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    var locationUpdateHandler: ((CLLocation) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        configureLocationManagerForBackgroundUpdates()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        userLocation = location
        locationUpdateHandler?(location)
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }

    private func configureLocationManagerForBackgroundUpdates() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .otherNavigation
    }

}
