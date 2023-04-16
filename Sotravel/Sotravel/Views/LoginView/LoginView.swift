import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var tripService: TripService
    @State private var isNavigationActive = false
    @State private var isLoading = false
    @State private var showSafariView = false

    var body: some View {
        // swiftlint:disable closure_body_length
        NavigationView {
            ScrollView {
                VStack {
                    Image("snowman")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 356, height: 480)
                        .clipped()
                        .overlay(alignment: .topLeading) {
                            Group {
                                Image("logo-circle")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, alignment: .center)
                                    .clipped()
                                    .padding()
                            }
                        }
                        .mask {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                        }
                        .padding()
                        .padding(.top, 40)
                        .shadow(color: .primary.opacity(0.15), radius: 18, x: 0, y: 14)
                    VStack(spacing: 10) {
                        NavigationLink(
                            destination: TripsPageView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitle("", displayMode: .inline),
                            isActive: $isNavigationActive) {
                            EmptyView()
                        }
                        if isLoading {
                            ProgressView()
                        } else {
                            LoginButtonView(
                                action: {
                                    showSafariView = true
                                },
                                title: "Continue with Telegram",
                                imageName: "paperplane.fill"
                            )
                            .fullScreenCover(isPresented: $showSafariView) {
                                SafariView(url: URL(string: "https://sotravel.me/app-login")!)
                            }
                            NavigationLink(destination: EmailLoginView()) {
                                Text("Continue With Email")
                                    .font(.uiButton)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                    .onOpenURL(perform: { url in
                        isLoading = true

                        if url.host != "app-login-success" {
                            return
                        }

                        // Ensure query params are present
                        guard let res = url.queryParameters else {
                            return
                        }

                        guard let idStr = res["user_id"], let token = res["token"] else {
                            isLoading = false
                            return
                        }

                        guard let id = UUID(uuidString: idStr) else {
                            return
                        }
                        userService.storeUserId(id: id)
                        userService.fetchAndCacheUserInBackground(id: id) { success in
                            if !success {
                                isLoading = false
                                return
                            }

                            userService.isLoggedIn = true
                            // TODO: Move this into some separate token storage class
                            NodeApi.storeAuthToken(token: token)
                            tripService.loadUserTrips(userId: id) { success in
                                if success {
                                    isNavigationActive = true
                                } else {
                                    // Handle case where load trips fails
                                }
                            }
                        }
                    })
                    Spacer()
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
