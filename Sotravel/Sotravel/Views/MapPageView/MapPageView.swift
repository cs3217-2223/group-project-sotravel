//
//  MapPageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 10/3/23.
//

import SwiftUI

struct MapPageView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = FriendsLocationViewModel()
    @State private var isSharingLocation = false

    var body: some View {
        VStack {
            MapView(userLocation: $locationManager.userLocation,
                    friendsLocations: $viewModel.friendsLocations)
                .edgesIgnoringSafeArea(.all)

            Toggle("Share My Location", isOn: $isSharingLocation)
                .padding()
                .onChange(of: isSharingLocation, perform: { _ in
                    if let userLocation = locationManager.userLocation {
                        // Replace "yourUserId" with the actual user ID from your authentication system.
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
