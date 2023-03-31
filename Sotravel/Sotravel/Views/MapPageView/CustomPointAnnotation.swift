import MapKit
import Foundation

class CustomPointAnnotation: MKPointAnnotation {
    var imageURL: String?
    var userId: UUID
    var isUser: Bool // Check if is user using the app

    init(userId: UUID, coordinate: CLLocationCoordinate2D, imageURL: String?, isUser: Bool) {
        self.userId = userId
        self.imageURL = imageURL
        self.isUser = isUser
        super.init()
        self.coordinate = coordinate
    }
}
