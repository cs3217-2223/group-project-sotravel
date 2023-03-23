import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userService: UserService
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var instagramUsername: String = ""
    @State private var tiktokUsername: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile")
                        .font(.uiHeadline)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Name")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                        TextField("Name", text: $name)
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
            .navigationBarBackButtonHidden(true)
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
        }
    }

    private func loadUserData() {
        name = userService.editProfileViewModel.name ?? "John Doe"
        description = userService.editProfileViewModel.description ?? ""
        instagramUsername = userService.editProfileViewModel.instagramUsername ?? ""
        tiktokUsername = userService.editProfileViewModel.tiktokUsername ?? ""
    }

    private func saveProfile() {
        // Implement the save logic here, e.g., updating the user object or saving to a database.
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView().environmentObject(UserService())
    }
}
