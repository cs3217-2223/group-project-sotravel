import SwiftUI

struct CreateInvitePageView: View {
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var tripService: TripService
    @EnvironmentObject private var viewAlertController: ViewAlertController
    @ObservedObject var createInvitePageUserViewModel: CreateInvitePageUserViewModel
    @State private var title: String = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var location: String = ""
    @State private var meetingPoint: String = ""
    @State private var description: String = ""
    @State private var selectedAttendees: [UUID] = []
    @State private var selectedAttendeesOption: Int = 0
    @State private var hasNavigatedToSeeMoreSelectedFriends = false

    let attendeesOptions = ["All Friends", "Selected friends"]
    var selectedFriends: [User] {
        createInvitePageUserViewModel.friends.filter { selectedAttendees.contains($0.id) }
    }
    var remainingFriends: [User] {
        createInvitePageUserViewModel.friends.filter { !selectedAttendees.contains($0.id) }
    }

    private func header() -> some View {
        HStack {
            Text("Create an invite ✨")
                .font(.uiTitle1)

            Spacer()
        }
        .padding(.leading)
        .padding(.top, 24)
    }

    private func inviteDetailsSection() -> some View {
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
    }

    private func dateAndTimeSection() -> some View {
        Section(header: Text("Date and time ⏱")) {
            DatePicker("Date", selection: $date, displayedComponents: .date)
            DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
        }
    }

    private func additionalInfoSection() -> some View {
        Section(header: Text("Additional Information 🗞")) {
            TextEditor(text: $description)
                .frame(height: 100)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }

    func friendProfileView(friend: User) -> some View {
        HStack {
            ProfileImageView(imageSrc: friend.imageURL, name: friend.name ?? "", width: 40, height: 40)
            Text(friend.name ?? "")
        }
    }

    func friendToggleView<Content: View>(friend: User, @ViewBuilder content: () -> Content, action: @escaping () -> Void = {}) -> some View {
        Toggle(isOn: Binding(
            get: { self.selectedAttendees.contains(friend.id) },
            set: { selected in
                if selected {
                    action()
                    self.selectedAttendees.append(friend.id)
                } else {
                    self.selectedAttendees.removeAll(where: { $0 == friend.id })
                }
            }
        )) {
            content()
        }
    }

    private func createInviteButton() -> some View {
        Button(action: {
            createEvent()
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
            .cornerRadius(10) // add corner radius
        }
    }

    private func attendeesSection() -> some View {
        Section(header: Text("Who are you inviting? 👥")) {
            Picker(selection: $selectedAttendeesOption, label: Text("Select attendees")) {
                ForEach(0..<attendeesOptions.count) { index in
                    Text(attendeesOptions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if selectedAttendeesOption == 0 {
                Text("This invite will be send to all your friends in \(tripService.getCurrTrip()?.title ?? "this trip").")
                    .font(.uiBody)
                ForEach(createInvitePageUserViewModel.friends.prefix(5), id: \.id) { friend in
                    friendProfileView(friend: friend)
                }
                NavigationLink(destination: FriendsListPageView(
                    friends: createInvitePageUserViewModel.friends,
                    actionComponent: {
                        friend in UserListItemLinkView(friend: friend)
                    }
                )
                ) {
                    VStack(alignment: .center) {
                        Text("See more")
                            .foregroundColor(.blue)
                    }
                }
            } else {
                if selectedFriends.isEmpty || !hasNavigatedToSeeMoreSelectedFriends {
                    ForEach(createInvitePageUserViewModel.friends.prefix(5), id: \.id) { friend in
                        friendToggleView(friend: friend, content: {
                            friendProfileView(friend: friend)
                        })
                    }
                } else {
                    if selectedFriends.isEmpty {
                        Text("You haven't selected any friends yet.")
                    }
                    ForEach(selectedFriends, id: \.id) { friend in
                        friendToggleView(friend: friend, content: {
                            friendProfileView(friend: friend)
                        })
                    }
                }

                NavigationLink(destination: FriendsListPageView(
                    friends: createInvitePageUserViewModel.friends,
                    actionComponent: {
                        friend in friendToggleView(
                            friend: friend,
                            content: {
                                VStack(spacing: 8) {
                                    UserListItemView(user: friend)
                                    Divider()
                                }
                            },
                            action: {
                                hasNavigatedToSeeMoreSelectedFriends = true
                            }
                        ).padding(.trailing)
                    }
                )
                ) {
                    VStack(alignment: .center) {
                        Text("See more")
                            .foregroundColor(.blue)
                    }
                }

            }
        }

    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    header()

                    Form {
                        inviteDetailsSection()
                        dateAndTimeSection()
                        additionalInfoSection()
                        attendeesSection()
                        createInviteButton()
                    }
                }.toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
            }
        }
    }

    private func createEvent() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            viewAlertController.showAlert(message: "Please enter a title for your invite.")
            return
        }
        guard !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            viewAlertController.showAlert(message: "Please enter a location for your invite.")
            return
        }

        guard !meetingPoint.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            viewAlertController.showAlert(message: "Please enter a meeting point for your invite.")
            return
        }

        guard let userId = userService.userId else {
            viewAlertController.showAlert(message: "Cannot find host user")
            return
        }

        guard let tripId = tripService.getCurrTripId() else {
            viewAlertController.showAlert(message: "TripId not found")
            return
        }
        let selected = selectedAttendeesOption == 0
            ? createInvitePageUserViewModel.friends.map { $0.id }
            : self.selectedAttendees

        let event = Event(
            tripId: tripId,
            title: title,
            details: description.isEmpty ? nil : description,
            status: nil,
            datetime: combineDateAndTime(date: date, time: time),
            meetingPoint: meetingPoint,
            location: location,
            hostUser: userId,
            invitedUsers: selected,
            attendingUsers: [],
            rejectedUsers: []
        )
        // Call event service to create event
        eventService.createEvent(event: event) { result in
            switch result {
            case .success:
                // Show success message and reset input fields
                viewAlertController.showAlert(message: "Woohoo! Your invite has been created ✨")
                title = ""
                location = ""
                meetingPoint = ""
                description = ""
                selectedAttendees = []
                selectedAttendeesOption = 0
                navigateToInvitesPage()
            case .failure(let error):
                // Show error message
                viewAlertController.showAlert(message: "Failed to create invite: \(error.localizedDescription)")
            }
        }
    }

    func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let combinedDateComponents = DateComponents(year: dateComponents.year,
                                                    month: dateComponents.month,
                                                    day: dateComponents.day,
                                                    hour: timeComponents.hour,
                                                    minute: timeComponents.minute)
        return calendar.date(from: combinedDateComponents)!
    }

    private func navigateToInvitesPage() {
        tripService.selectedTapInCurrTrip = 1
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateInvitePageView(createInvitePageUserViewModel: CreateInvitePageUserViewModel(friends: mockFriends))
                .environmentObject(EventService())
                .environmentObject(UserService())
                .environmentObject(TripService())
        }
    }
}
