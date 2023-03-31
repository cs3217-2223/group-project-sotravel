import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var friendsLocations: [String: CLLocation]
    @Binding var selectedFriend: User?
    @Binding var isSharingLocation: Bool
    @EnvironmentObject var userService: UserService

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .satelliteFlyover
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(from: mapView)

        self.setZoomLevelIfNotZoomedIn(mapView)
    }

    func setZoomLevelIfNotZoomedIn(_ mapView: MKMapView) {
        let currentSpan = mapView.region.span
        let thresholdLatitudeDelta: CLLocationDegrees = 0.01
        let thresholdLongitudeDelta: CLLocationDegrees = 0.01

        if currentSpan.latitudeDelta > thresholdLatitudeDelta || currentSpan.longitudeDelta > thresholdLongitudeDelta {
            self.centerMapOnUserLocation(mapView)
        }
    }

    func centerMapOnUserLocation(_ mapView: MKMapView) {
        guard let userLocation = userLocation else {
            return
        }
        let desiredLatitudeDelta: CLLocationDegrees = 0.005
        let desiredLongitudeDelta: CLLocationDegrees = 0.005
        let desiredSpan = MKCoordinateSpan(latitudeDelta: desiredLatitudeDelta, longitudeDelta: desiredLongitudeDelta)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: desiredSpan)
        mapView.setRegion(region, animated: true)
    }

    private func updateAnnotations(from mapView: MKMapView) {
        // Prepare a dictionary with userId as key and annotations as value
        var existingAnnotations: [UUID: CustomPointAnnotation] = [:]
        for annotation in mapView.annotations {
            if let customAnnotation = annotation as? CustomPointAnnotation {
                existingAnnotations[customAnnotation.userId] = customAnnotation
            }
        }

        for (friendId, friendLocation) in friendsLocations {
            guard let friendUUID = UUID(uuidString: friendId) else {
                continue
            }

            if let existingAnnotation = existingAnnotations[friendUUID] {
                // Update the existing annotation
                existingAnnotation.coordinate = friendLocation.coordinate
                continue
            }

            let friendAnnotation = CustomPointAnnotation(
                userId: friendUUID,
                coordinate: friendLocation.coordinate,
                // TODO: Using mock data should fetch name and image from friendService
                title: "John Doe",
                imageURL: mockUser1.imageURL,
                isUser: false
            )
            mapView.addAnnotation(friendAnnotation)
        }

        // Handle user annotation
        guard let user = userService.getUser(), let userCoordinate = userLocation?.coordinate else {
            return
        }

        if !isSharingLocation {
            // Remove user annotation
            guard let userAnnotation = existingAnnotations[user.id] else {
                return
            }

            mapView.removeAnnotation(userAnnotation)
            return
        }

        if let exisitingAnnotation = existingAnnotations[user.id] {
            exisitingAnnotation.coordinate = userCoordinate
        } else {
            mapView.addAnnotation(CustomPointAnnotation(
                userId: user.id,
                coordinate: userCoordinate,
                title: user.name,
                imageURL: user.imageURL,
                isUser: true
            ))
        }
    }
}
