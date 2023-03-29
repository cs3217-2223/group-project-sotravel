import SwiftUI

struct MapPageView: View {
    @StateObject var locationManagerService = LocationManagerService()
    @StateObject var mapStorageService = MapStorageService(mapRepository: FirebaseMapRepository())
    @EnvironmentObject var userService: UserService
    @State private var selectedFriend: User?
    @State private var isSharingLocation = true

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    MapView(
                        userLocation: $locationManagerService.userLocation,
                        friendsLocations: $mapStorageService.friendsLocations,
                        selectedFriend: $selectedFriend
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        guard let user = userService.user else {
                            return
                        }

                        mapStorageService
                            .startUserLocationUpdate(
                                locationManager: locationManagerService,
                                userId: user.id.uuidString
                            )
                    }
                    .sheet(item: $selectedFriend) { friend in
                        FriendProfilePageView(friend: friend)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                guard let user = userService.user else {
                                    return
                                }

                                isSharingLocation.toggle()

                                if isSharingLocation {
                                    mapStorageService
                                        .startUserLocationUpdate(
                                            locationManager: locationManagerService,
                                            userId: user.id.uuidString
                                        )
                                } else {
                                    mapStorageService
                                        .stopUserLocationUpdate(
                                            locationManager: locationManagerService,
                                            userId: user.id.uuidString
                                        )
                                }
                            }) {
                                Image(systemName: isSharingLocation ? "location.fill" : "location.slash")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
                }
            }.padding(.bottom, 12)
            //            HStack {
            //                LabelledToggleView(icon: "antenna.radiowaves.left.and.right",
            //                                   title: "Find Me",
            //                                   subtitle: "Share Location with Friends",
            //                                   isOn: $isSharingLocation)
            //                .onChange(of: isSharingLocation, perform: { _ in
            //                    guard let user = userService.user else {
            //                        return
            //                    }
            //
            //                    if isSharingLocation {
            //                        mapStorageService
            //                            .startUserLocationUpdate(
            //                                locationManager: locationManagerService,
            //                                userId: user.id.uuidString
            //                            )
            //                    } else {
            //                        mapStorageService
            //                            .stopUserLocationUpdate(
            //                                locationManager: locationManagerService,
            //                                userId: user.id.uuidString
            //                            )
            //                    }
            //                })
            //                Spacer()
            //            }
        }
    }

    struct MapPageView_Previews: PreviewProvider {
        static var previews: some View {
            let meUser = UserService()
            MapPageView().environmentObject(meUser)
        }
    }
}
