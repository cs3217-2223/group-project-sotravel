import SwiftUI

struct EmailSignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var userService: UserService
    @EnvironmentObject private var tripService: TripService

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .autocapitalization(.none)
                    .padding(.bottom, 12)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)

                SecureField("Password", text: $password)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding(.bottom, 12)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Confirm Password", text: $password)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding(.bottom, 12)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                LoginButtonView(action: {
//                    userService.emailSignin(email: email, password: password) {success, userId in
//                        if !success {
//                            return
//                        }
//
//                        guard let userId = userId else {
//                            return
//                        }
//
//                        userService.isLoggedIn = true
//                        userService.storeUserId(id: userId)
//                        tripService.loadUserTrips(userId: userId) { _ in }
//                    }
                }, title: "Sign Up", imageName: nil, url: nil)
                .padding(.bottom, 12)

                Spacer()
            }
            .padding()
        }
    }
}
