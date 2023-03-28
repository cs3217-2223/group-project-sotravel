import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var userService: UserService
    @ObservedObject var viewModel: EditProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var description: String = ""
    @State private var instagramUsername: String = ""
    @State private var tiktokUsername: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile")
                        .font(.uiHeadline)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("First Name")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)

                        Text("Last Name")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)

                        Text("Description")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        TextField("Description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)
                    }

                    Text("Socials")
                        .font(.uiHeadline)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instagram Username")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                        TextField("Instagram Username", text: $instagramUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)

                        Text("TikTok Username")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        TextField("TikTok Username", text: $tiktokUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)
                    }
                }
                .padding()
            }
            .onAppear {
                loadUserData()
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.blue)
                    Text("Back")
                },
                trailing: Button("Save") {
                    saveProfile()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
        .alert("Error in updating profile",
               isPresented: $viewModel.updateError) {
            Button("ok") {
                userService.toggleEditProfileViewAlert()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func loadUserData() {
        firstName = viewModel.firstName ?? ""
        lastName = viewModel.lastName ?? ""
        description = viewModel.description ?? ""
        instagramUsername = viewModel.instagramUsername ?? ""
        tiktokUsername = viewModel.tiktokUsername ?? ""
    }

    private func saveProfile() {
        userService.editUser(firstName: firstName,
                             lastName: lastName,
                             description: description,
                             instagramUsername: instagramUsername,
                             tiktokUsername: tiktokUsername)
        userService.updateUser()
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: EditProfileViewModel()).environmentObject(UserService())
    }
}
