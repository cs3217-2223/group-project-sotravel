import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userService: UserService
    @State private var isNavigationActive = false
    @State private var isLoading = false
    var body: some View {
        NavigationStack {
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
                    .shadow(color: .black.opacity(0.15), radius: 18, x: 0, y: 14)
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
                    //                                .fill(Color.uiPrimary.opacity(0.1)))
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
                            isLoading = true
                            userService.fetchUser(id: UUID()) { success in
                                if success {
                                    isNavigationActive = true
                                } else {
                                    isLoading = false
                                }
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(.white)
                                Text("Continue with Telegram")
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
