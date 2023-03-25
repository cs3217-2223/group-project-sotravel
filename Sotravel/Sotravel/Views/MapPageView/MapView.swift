import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var friendsLocations: [String: CLLocation]

    @State private var initialMapLoad = true

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Set the map type to satellite 3D
        mapView.mapType = .satelliteFlyover

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(from: mapView)

        if initialMapLoad, let userLocation = userLocation {
            let region = MKCoordinateRegion(center: userLocation.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            initialMapLoad = false
        }
    }

    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        guard let userLocation = userLocation else {
            return
        }

        let currentLocationAnnotation = MKPointAnnotation()
        currentLocationAnnotation.coordinate = userLocation.coordinate
        currentLocationAnnotation.title = "You"

        mapView.addAnnotation(currentLocationAnnotation)

        for (friend, location) in friendsLocations {
            let friendAnnotation = MKPointAnnotation()
            friendAnnotation.coordinate = location.coordinate
            friendAnnotation.title = friend

            mapView.addAnnotation(friendAnnotation)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }

}
