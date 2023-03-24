import MapKit

class UserAnnotationView: MKAnnotationView {
    static let identifier = "UserAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        canShowCallout = true
        image = UIImage(named: "default_user_image") // Replace with the default user image name
    }
}
