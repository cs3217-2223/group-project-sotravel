import SwiftUI

struct CreateInvitePageView: View {
    @EnvironmentObject var userService: UserService
    @State private var title: String = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var location: String = ""
    @State private var meetingPoint: String = ""
    @State private var description: String = ""
    @State private var selectedAttendees: [User] = []
    @State private var selectedAttendeesOption: Int = 0

    let attendeesOptions = ["All Friends", "Selected friends"]

    var body: some View {
        VStack {
            HStack {
                Text("Create an invite ✨")
                    .font(.uiTitle1)

                Spacer()
            }
            .padding(.leading)
            .padding(.top, 24)

            Form {
                Section(header: Text("Invite Details ✍️")) {
                    TextField("Activity (e.g. Rock Climbing)", text: $title)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .font(.body)
                    TextField("Location (e.g. Railay Beach)", text: $location)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    TextField("Meeting Point (e.g. Hotel Lobby)", text: $meetingPoint)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Date and time ⏱")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                }

                Section(header: Text("Additional Information 🗞")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }

                Section(header: Text("Who are you inviting? 👥")) {
                    Picker(selection: $selectedAttendeesOption, label: Text("Select attendees")) {
                        ForEach(0..<attendeesOptions.count) { index in
                            Text(attendeesOptions[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    if selectedAttendeesOption == 0 {
                        Text("This invite will be send to all your friends in the same city.").font(.uiBody)
                    } else {
                        if let user = userService.user {
                            ForEach(user.friends, id: \.id) { friend in
                                Toggle(isOn: Binding(
                                    get: { self.selectedAttendees.contains(friend) },
                                    set: { selected in
                                        if selected {
                                            self.selectedAttendees.append(friend)
                                        } else {
                                            self.selectedAttendees.removeAll(where: { $0 == friend })
                                        }
                                    }
                                )) {
                                    Text(friend.name ?? "John Doe")
                                }
                            }
                        }
                    }
                }

                Button(action: {
                    // Create event action
                }) {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "plus")
                        Text("Create Invite")
                    }
                    .font(.body.weight(.medium))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .foregroundColor(.blue)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.clear.opacity(0.25), lineWidth: 0)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white))
                    }
                }
            }
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateInvitePageView().environmentObject(UserService())
        }
    }
}
