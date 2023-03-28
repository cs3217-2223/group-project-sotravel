import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var friendsLocations: [String: CLLocation]
    @EnvironmentObject var userService: UserService
    @State private var initialMapLoad = true

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(from: mapView)

        if initialMapLoad, let userLocation = userLocation {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            initialMapLoad = false
        }
    }

    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        guard let userLocation = userLocation else { return }

        let currentLocationAnnotation = CustomPointAnnotation(
            userId: userService.user.id,
            coordinate: userLocation.coordinate,
            title: userService.user.name,
            imageURL: userService.user.imageURL
        )

        mapView.addAnnotation(currentLocationAnnotation)

        for (friendId, friendLocation) in friendsLocations {
            let friendService = UserService()
            if let id = UUID(uuidString: friendId) {
                friendService.fetchUser(id: id)

                let friendAnnotation = CustomPointAnnotation(
                    userId: friendService.user.id,
                    coordinate: friendLocation.coordinate,
                    title: friendService.user.name,
                    imageURL: friendService.user.imageURL
                )

                mapView.addAnnotation(friendAnnotation)
            }
        }
    }
}
