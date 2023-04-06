import SwiftUI

struct EmailLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject user: UserService

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

            LoginButtonView(action: {
                
            }, title: "Sign In", imageName: nil, url: nil)

            Spacer()
        }
        .padding()
    }
}

struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView()
    }
}
