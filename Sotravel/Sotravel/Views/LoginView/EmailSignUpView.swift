import SwiftUI

// TODO: Remove if unnnecessary by 12 Apr
// NOTE: Do not use. Not complete. Requires some additional refactoring
// The code is here in case, iOS App Store checker needs a sign up in the app
struct EmailSignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @EnvironmentObject var userService: UserService
    @EnvironmentObject private var tripService: TripService

    var body: some View {
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

            SecureField("Confirm Password", text: $confirmPassword)
                .frame(height: 55)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding(.bottom, 12)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            LoginButtonView(action: {
                if password != confirmPassword {
                    showAlert = true
                }
                userService.emailSignup(email: email, password: password) {success, userId in
                    if !success {
                        return
                    }

                    guard let userId = userId else {
                        return
                    }

                    userService.isLoggedIn = true
                    userService.storeUserId(id: userId)
                    tripService.loadUserTrips(userId: userId) { _ in }
                }
            }, title: "Sign Up", imageName: nil, url: nil)
            .padding(.bottom, 12)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("The passwords don't match"),
                      message: Text("Password and confirm password do not match."),
                      dismissButton: .default(
                        Text("OK"),
                        action: {
                            showAlert = false
                        }
                      ))
            }

            Spacer()
        }
        .padding()
    }

}
