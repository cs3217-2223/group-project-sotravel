import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @State private var isNavigationActive = false
    @State private var isLoading = false
    var body: some View {
        // swiftlint:disable closure_body_length
        NavigationView {
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
                    //                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                    //                        Image(systemName: "envelope.fill")
                    //                            .imageScale(.medium)
                    //                        Text("Continue with Gmail").font(.uiButton)
                    //                    }
                    //                    .font(.uiBody.weight(.medium))
                    //                    .padding(.vertical, 16)
                    //                    .frame(maxWidth: .infinity)
                    //                    .clipped()
                    //                    .foregroundColor(Color.uiPrimary)
                    //                    .background {
                    //                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    //                            .stroke(.clear.opacity(0.25), lineWidth: 0)
                    //                            .background(RoundedRectangle(cornerRadius: 10,
                    //                                                         style: .continuous)
                    //                                            .fill(Color.uiPrimary.opacity(0.1)))
                    //                    }
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
                        Button(action: {

                        }) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(.white)
                                Link("Continue with Telegram",
                                     destination: URL(string: "https://sotravel.me/app-login")!)
                                    .foregroundColor(.white).font(.uiButton)
                            }
                            .font(.uiBody.weight(.medium))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .foregroundColor(Color(.systemBackground))
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.uiPrimary)
                            }
                        }
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

                    userService.fetchUser(id: id) { success in
                        if success {
                            // TODO: Move this into some separate token storage class
                            NodeApi.storeAuthToken(token: token)
                            userService.fetchAllFriends(tripId: 1) { _ in
                                // empty for now
                            }
                            // TODO: Remove hardcoded trip id and user id
                            eventService.loadUserEvents(forTrip: 1, userId: mockUser.id)
                            isNavigationActive = true
                        } else {
                            isLoading = false
                        }
                    }
                })
                Spacer()
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
