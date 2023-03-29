import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var friendsLocations: [String: CLLocation]
    @Binding var selectedFriend: User?
    @EnvironmentObject var userService: UserService
    @State var firstLoad = true

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

        print("firstLoad", firstLoad)
        if firstLoad {
            centerMapOnUserLocation(mapView)
            firstLoad = false
        }
    }

    func centerMapOnUserLocation(_ mapView: MKMapView) {
        guard let userLocation = userLocation else {
            return
        }

        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
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

        guard let user = userService.user, let userCoordinate = userLocation?.coordinate else {
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
    }
}
