import MapKit
import SwiftUI

// Displays the user coordinate on the map view
class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var imageCache: [UUID: UIImage] = [:]
    let bubbleSize: CGFloat = 32

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomPointAnnotation else { return nil

        }

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
                        self.imageCache[customAnnotation.userId] = self.resizeImage(
                            image: image, fixedWidth: self.bubbleSize,
                            fixedHeight: self.bubbleSize
                        )
                        annotationView?.image = self.imageCache[customAnnotation.userId]
                    }
                }
            }
            task.resume()
        }

        // If is user then have higher display priority
        if customAnnotation.isUser {
            annotationView?.displayPriority = .required
            annotationView?.layer.zPosition = 10
            annotationView?.layer.cornerRadius = bubbleSize / 2
            annotationView?.layer.borderColor = UIColor.systemBlue.cgColor
            annotationView?.layer.borderWidth = 2
        } else {
            annotationView?.layer.zPosition = 1
        }

        annotationView?.layer.shadowColor = UIColor.black.cgColor
        annotationView?.layer.shadowOpacity = 0.5
        annotationView?.layer.shadowOffset = CGSize(width: 2, height: 2)
        annotationView?.layer.shadowRadius = 4

        return annotationView
    }

    // Redirects to friend page on click
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? CustomPointAnnotation, !customAnnotation.isUser {
            // let friend = fetchFriend(customAnnotation.userId)
            // TODO: fetch actual user
            parent.selectedFriend = mockUser3
        }
    }

    func resizeImage(image: UIImage, fixedWidth: CGFloat, fixedHeight: CGFloat) -> UIImage? {
        let newSize = CGSize(width: fixedWidth, height: fixedHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: newSize), cornerRadius: newSize.width / 2)
        path.addClip()

        image.draw(in: CGRect(origin: .zero, size: newSize))
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return circularImage
    }
}
