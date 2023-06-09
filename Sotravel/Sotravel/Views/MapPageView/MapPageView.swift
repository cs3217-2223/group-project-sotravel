import SwiftUI

struct MapPageView: View {
    @StateObject var locationManagerService = LocationManagerService()
    @StateObject var mapStorageService = MapStorageService(mapRepository: FirebaseMapRepository())
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var locationSharing: LocationSharingViewModel
    @State private var selectedFriend: User?
    @State private var showToast = false
    @State private var userId: UUID?

    private func toggleToast() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showToast = false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    MapView(
                        userLocation: $locationManagerService.userLocation,
                        friendsLocations: $mapStorageService.friendsLocations,
                        selectedFriend: $selectedFriend,
                        isSharingLocation: $locationSharing.isSharingLocation
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        guard let userId = userService.currentUserId else {
                            return
                        }

                        mapStorageService
                            .startUserLocationUpdate(
                                locationManager: locationManagerService,
                                userId: userId.uuidString
                            )
                    }
                    .sheet(item: $selectedFriend) { friend in
                        VStack {
                            Capsule()
                                .frame(width: 80, height: 5)
                                .foregroundColor(.gray)
                                .padding(.top)
                                .padding(.bottom)
                            FriendProfilePageView(friend: friend)
                        }
                    }

                    VStack {
                        if showToast {
                            Toast(message: locationSharing.isSharingLocation ? "Sharing location" : "Stopped sharing location")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black.opacity(0.1))
                                .edgesIgnoringSafeArea(.all)
                                .transition(.opacity)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                guard let userId = userService.currentUserId else {
                                    return
                                }

                                toggleToast()
                                locationSharing.isSharingLocation.toggle()

                                if locationSharing.isSharingLocation {
                                    locationManagerService.startUpdatingLocation()

                                    mapStorageService
                                        .startUserLocationUpdate(
                                            locationManager: locationManagerService,
                                            userId: userId.uuidString
                                        )
                                } else {
                                    locationManagerService.stopUpdatingLocation()

                                    mapStorageService
                                        .stopUserLocationUpdate(
                                            locationManager: locationManagerService,
                                            userId: userId.uuidString
                                        )
                                }
                            }) {
                                Image(systemName: locationSharing.isSharingLocation ?
                                        "antenna.radiowaves.left.and.right" :
                                        "antenna.radiowaves.left.and.right.slash")
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
            }.padding(.bottom, 6)
        }
    }

    struct MapPageView_Previews: PreviewProvider {
        static var previews: some View {
            MapPageView()
                .environmentObject(UserService())
                .environmentObject(FriendService())
        }
    }
}
