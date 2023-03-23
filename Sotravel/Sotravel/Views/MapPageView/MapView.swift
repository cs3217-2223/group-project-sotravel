import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var userLocation: CLLocation?
    @Binding var friendsLocations: [String: CLLocation]

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
    }

    private func updateAnnotations(from mapView: MKMapView) {
        guard let userLocation = userLocation else { return }

        let currentLocationAnnotation = MKPointAnnotation()
        currentLocationAnnotation.coordinate = userLocation.coordinate
        currentLocationAnnotation.title = "You"

        mapView.addAnnotation(currentLocationAnnotation)
        mapView.showAnnotations([currentLocationAnnotation], animated: true)

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
