import MapKit
import Foundation

class CustomPointAnnotation: MKPointAnnotation {
    var imageURL: String?
    var userId: UUID

    init(userId: UUID, coordinate: CLLocationCoordinate2D, title: String?, imageURL: String?) {
        self.userId = userId
        self.imageURL = imageURL
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}
