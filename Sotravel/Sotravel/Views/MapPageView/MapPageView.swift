import SwiftUI

struct MapPageView: View {
    @StateObject var locationManager = LocationManagerService()
    @StateObject var viewModel = FriendsLocationViewModel()
    @State private var isSharingLocation = true

    var body: some View {
        VStack {
            MapView(userLocation: $locationManager.userLocation,
                    friendsLocations: $viewModel.friendsLocations)
                .edgesIgnoringSafeArea(.all)

            LabelledToggleView(icon: "antenna.radiowaves.left.and.right",
                               title: "Find Me",
                               subtitle: "Share Location with Friends",
                               isOn: $isSharingLocation)
                .onChange(of: isSharingLocation, perform: { _ in
                    if let userLocation = locationManager.userLocation {
                        viewModel.updateCurrentUserLocation(userLocation, userId: "yourUserId")
                    }
                })
        }
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        MapPageView()
    }
}
