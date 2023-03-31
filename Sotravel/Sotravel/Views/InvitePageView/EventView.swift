import SwiftUI

struct EventView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var friendService: FriendService
    @ObservedObject var eventViewModel: EventViewModel
    var isHideButton = false

    var body: some View {
        VStack {
            HStack(spacing: 47) {
                DateTimeView(datetime: eventViewModel.datetime)
                EventDetailsView(eventViewModel: eventViewModel)
            }
            if !isHideButton {
                if let userId = userService.getUserId() {
                    Group {
                        NavigationLink(destination: EventPageView(eventViewModel: eventViewModel)) {
                            if eventViewModel.hostUser == userId {
                                Text("You're hosting 😊")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.purple)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.purple, lineWidth: 2)
                                    )
                                    .cornerRadius(10)
                            } else if eventViewModel.eventStatus == EventStatus.going {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Going")
                                }
                                .font(.uiButton)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .foregroundColor(Color.green)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.clear.opacity(0.25), lineWidth: 0)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(Color.green.opacity(0.1)))
                                }
                            } else if eventViewModel.eventStatus == EventStatus.notGoing {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Not Going")
                                }
                                .font(.uiButton)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .foregroundColor(Color.red)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.clear.opacity(0.25), lineWidth: 0)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(Color.red.opacity(0.1)))
                                }
                            } else {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("View")
                                }
                                .font(.uiButton)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .foregroundColor(Color.uiPrimary)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.clear.opacity(0.25), lineWidth: 0)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(Color.uiPrimary.opacity(0.1)))
                                }
                            }

                        }
                    }
                    .onAppear {
                        eventViewModel.updateEventStatus(userId: userId)
                    }
                }
            }
        }
        .padding(16)
        .clipped()
        .mask { RoundedRectangle(cornerRadius: 20, style: .continuous) }
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.3), lineWidth: 1))
    }
}

struct EventDetailsView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var friendService: FriendService
    @ObservedObject var eventViewModel: EventViewModel

    var body: some View {
        VStack(spacing: 7) {
            Text(eventViewModel.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .font(.uiHeadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text(eventViewModel.location)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .font(.uiCallout)
                .foregroundColor(.gray)
                .padding(.top, 4)
                .lineLimit(1)
            NavigationLink(destination: EventPageView(eventViewModel: eventViewModel)) {
                AttendingUsersView(attendingUsers: eventViewModel.attendingUsers)
            }

            // New section to display host user
            if let hostUser = self.getUser(id: eventViewModel.hostUser) {
                Text("Hosted by \(hostUser.name ?? "Unknown")")
                    .font(.uiFootnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
        }
    }

    private func getUser(id: UUID) -> User? {
        if let friend = friendService.getFriend(id: id) {
            return friend
        } else if let userId = userService.getUserId(), userId == id {
            return userService.getUser()
        } else {
            return nil
        }
    }
}

struct AttendingUsersView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var friendService: FriendService
    var attendingUsers: [UUID]

    private func profileOffset(index: Int, totalCount: Int) -> CGFloat {
        CGFloat(22 * (totalCount - index - 1))
    }

    var body: some View {
        HStack(spacing: 0) {
            Text("\(attendingUsers.count) Going")
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .font(.uiFootnote)
                .foregroundColor(.blue.opacity(0.8))

            let renderedUserIds = attendingUsers.prefix(3)

            ZStack {
                ForEach(Array(renderedUserIds.enumerated()), id: \.1) { index, userId in
                    if let user = self.getUser(id: userId) {
                        let xOffset = profileOffset(index: index, totalCount: renderedUserIds.count)
                        ProfileImageView(
                            imageSrc: user.imageURL ?? "",
                            name: user.name ?? "JohnDoe",
                            width: 30,
                            height: 30
                        )
                        .offset(x: xOffset)
                    }
                }
            }.offset(x: -50)
        }
        .padding(.top, 1)
    }

    private func getUser(id: UUID) -> User? {
        if let friend = friendService.getFriend(id: id) {
            return friend
        } else if let userId = userService.getUserId(), userId == id {
            return userService.getUser()
        } else {
            return nil
        }
    }
}

struct DateTimeView: View {
    let datetime: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(datetime.toFriendlyTimeString())
                .font(.uiHeadline)
                .foregroundColor(Color.primary)
            Text(datetime.toFriendlyDateString())
                .font(.uiCallout)
                .foregroundColor(Color.gray)
        }.offset(x: 4, y: -7)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        let eventVM = EventViewModel(title: "Test event VM", datetime: Date(), location: "COM1", meetingPoint: "COM1")
        EventView(eventViewModel: eventVM).environmentObject(UserService())
    }
}
