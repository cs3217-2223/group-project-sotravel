import MapKit
import SwiftUI

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var imageCache: [UUID: UIImage] = [:]

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomPointAnnotation else { return nil }

        let identifier = "userAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customAnnotation
        }

        // Load and set the image from cache or download it
        if let cachedImage = imageCache[customAnnotation.userId] {
            annotationView?.image = cachedImage
        } else if let imageUrl = customAnnotation.imageURL, let url = URL(string: imageUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(String(describing: error))")
                    return
                }

                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        // Resize the image to a larger size if needed.
                        self.imageCache[customAnnotation.userId] = self.resizeImage(image: image, fixedWidth: 48)
                        annotationView?.image = self.imageCache[customAnnotation.userId]
                    }
                }
            }
            task.resume()
        }

        // Add user's name below the image and add shadow to the image
        let nameLabel = UILabel()
        nameLabel.text = customAnnotation.title
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.sizeToFit()

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: nameLabel.frame.width, height: nameLabel.frame.height))
        customView.addSubview(nameLabel)

        annotationView?.leftCalloutAccessoryView = customView
        annotationView?.layer.shadowColor = UIColor.black.cgColor
        annotationView?.layer.shadowOpacity = 0.5
        annotationView?.layer.shadowOffset = CGSize(width: 2, height: 2)
        annotationView?.layer.shadowRadius = 4

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let customAnnotation = view.annotation as? CustomPointAnnotation {
//            parent.userService.fetchUser(id: customAnnotation.userId)
            // Navigate to the user's profile page
        }
    }

    func resizeImage(image: UIImage, fixedWidth: CGFloat) -> UIImage? {
        let aspectRatio = image.size.height / image.size.width
        let newSize = CGSize(width: fixedWidth, height: fixedWidth * aspectRatio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: newSize), cornerRadius: newSize.width / 2)
        path.addClip()

        image.draw(in: CGRect(origin: .zero, size: newSize))
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return circularImage
    }
}
