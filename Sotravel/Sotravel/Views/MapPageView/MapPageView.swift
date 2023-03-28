import SwiftUI

struct MapPageView: View {
    @StateObject var locationManagerService = LocationManagerService()
    @StateObject var mapStorageService = MapStorageService(mapRepository: FirebaseMapRepository())
    @EnvironmentObject var userService: UserService
    @State private var isSharingLocation = true

    var body: some View {
        NavigationView {
            VStack {
                MapView(userLocation: $locationManagerService.userLocation,
                        friendsLocations: $mapStorageService.friendsLocations)
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    LabelledToggleView(icon: "antenna.radiowaves.left.and.right",
                                       title: "Find Me",
                                       subtitle: "Share Location with Friends",
                                       isOn: $isSharingLocation)
                        .onChange(of: isSharingLocation, perform: { _ in
                            guard let user = userService.user else {
                                return
                            }

                            if isSharingLocation, let userLocation = locationManagerService.userLocation {
                                mapStorageService
                                    .updateCurrentUserLocation(
                                        userLocation,
                                        userId: user.id.uuidString
                                    )

                            } else {
                                mapStorageService.removeCurrentUserLocation(userId: user.id.uuidString)
                            }
                        })
                    Spacer()
                }
            }
        }
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        let meUser = UserService()
        MapPageView().environmentObject(meUser)
    }
}
