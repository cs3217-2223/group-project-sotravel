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

        guard let user = userService.user else { return }

        let currentLocationAnnotation = CustomPointAnnotation(
            userId: user.id,
            coordinate: userLocation.coordinate,
            title: user.name,
            imageURL: user.imageURL
        )

        mapView.addAnnotation(currentLocationAnnotation)

        for (friendId, friendLocation) in friendsLocations {
            let friendService = UserService()

            guard let id = UUID(uuidString: friendId) else {
                continue
            }

            friendService.fetchUser(id: id, completion: { _ in })

            guard let friend = friendService.user else {
                continue
            }

            let friendAnnotation = CustomPointAnnotation(
                userId: friend.id,
                coordinate: friendLocation.coordinate,
                title: friend.name,
                imageURL: friend.imageURL
            )

            mapView.addAnnotation(friendAnnotation)
        }
    }
}
