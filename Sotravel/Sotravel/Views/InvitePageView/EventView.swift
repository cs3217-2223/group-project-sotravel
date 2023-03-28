import SwiftUI

struct EventView: View {
    @EnvironmentObject private var userService: UserService
    @ObservedObject var eventViewModel: EventViewModel
    var isHideButton = false

    var body: some View {
        VStack {
            HStack(spacing: 47) {
                DateTimeView(datetime: eventViewModel.datetime)
                EventDetailsView(eventViewModel: eventViewModel)
                    .onAppear {
                        Task {
                            for userId in eventViewModel.attendingUsers {
                                await userService.fetchUserIfNeededFrom(id: userId)
                            }
                        }
                    }
            }
            if !isHideButton {
                NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel, eventViewModel: eventViewModel)) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Join")
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
        .padding(16)
        .clipped()
        .mask { RoundedRectangle(cornerRadius: 20, style: .continuous) }
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.3), lineWidth: 1))
    }
}

struct EventDetailsView: View {
    @EnvironmentObject private var userService: UserService
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
            NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel,
                                                      eventViewModel: eventViewModel)) {
                AttendingUsersView(attendingUsers: eventViewModel.attendingUsers)
            }
        }
    }
}

struct AttendingUsersView: View {
    @EnvironmentObject private var userService: UserService
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
                    if let user = userService.userCache[userId] {
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
}

struct DateTimeView: View {
    let datetime: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(datetime.toFriendlyTimeString())
                .font(.uiHeadline)
                .foregroundColor(Color.black)
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
