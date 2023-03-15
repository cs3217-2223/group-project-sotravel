import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile")
                        .font(.uiHeadline)


                    VStack(alignment: .leading, spacing: 5) {
                        Text("Name")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                        TextField("Name", text: $user.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)

                        Text("Description")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        TextField("Description", text: $user.description)
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
                        TextField("Instagram Username", text: $user.instagramUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)

                        Text("TikTok Username")
                            .font(.uiSubheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        TextField("TikTok Username", text: $user.tiktokUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.uiBody)
                    }
                }
                .padding()
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
    }

    private func saveProfile() {
        // Implement the save logic here, e.g., updating the user object or saving to a database.
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView().environmentObject(mockUser)
    }
}
