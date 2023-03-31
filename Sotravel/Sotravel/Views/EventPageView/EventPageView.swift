import SwiftUI

struct EventPageView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var chatService: ChatService
    @ObservedObject var eventPageUserViewModel: EventPageUserViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var eventViewModel: EventViewModel
    @State private var selectedTab = 0
    @State private var eventStatus = EventStatus.pending
    @State private var showConfirmationDialog = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(eventViewModel.title)
                        .font(.uiTitle2)
                        .lineLimit(1)
                    Spacer()
                }.padding(.bottom, 10)
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                    Text(eventViewModel.datetime.formattedDateAndTime())
                        .font(.uiCallout)
                }
                HStack {
                    Image(systemName: "location.fill")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                    Text(eventViewModel.location)
                        .font(.uiCallout)
                }
                if let eventDetails = eventViewModel.details {
                    Text(eventDetails)
                        .font(.uiBody)
                        .foregroundColor(.primary.opacity(0.5))
                        .padding(.vertical, 8)
                }
                // Attendees status
                VStack {
                    HStack {
                        Text("Who's in? 👋")
                            .font(.uiTitle3)
                        Spacer()
                    }

                    AttendeesView(eventViewModel: eventViewModel)

                }.padding(.top, 6)
                VStack {
                    EventStatusButton(eventStatusUserViewModel: userService.eventStatusButtonViewModel,
                                      eventViewModel: eventViewModel,
                                      eventStatus: $eventStatus)
                }.padding(.top, 16)
                // Attendees status
                VStack {
                    HStack {
                        Text("Latest messages")
                            .font(.uiTitle3)
                        Spacer()
                    }

                    // TODO: latest messages
                    /*
                     VStack {
                     // Get latest 3 messages
                     ForEach(chat.messages.sorted { $0.timestamp > $1.timestamp }.prefix(3), id: \.id) {message in
                     ChatMessageView(chatMessage: message, isSentByMe: message.sender == eventPageUserViewModel.userId).font(.body)
                     .id(message.id)
                     }
                     }.padding(.top, 3)
                     .padding(.bottom, 14)
                     */
                    NavigationLink(destination: ChatView()) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: "message.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.monochrome)
                                .foregroundColor(.white)
                            Text("View Chat")
                                .foregroundColor(.white).font(.uiButton)
                        }
                        .font(.uiButton)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .foregroundColor(Color(.systemBackground))
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.uiPrimary)
                        }
                    }.simultaneousGesture(TapGesture().onEnded {
                        chatService.fetchEventChat(eventId: eventViewModel.id)
                    })
                    if eventViewModel.hostUser == eventPageUserViewModel.userId {
                        CancelEventButton(eventViewModel: eventViewModel, showConfirmationDialog: $showConfirmationDialog)
                            .padding(.top, 18)
                    }
                }
                .padding(.top, 18)
                .onAppear {
                    updateEventStatus()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private func updateEventStatus() {
        if eventViewModel.attendingUsers.contains(eventPageUserViewModel.userId)
            || eventViewModel.hostUser == eventPageUserViewModel.userId {
            eventStatus = .going
        } else if eventViewModel.rejectedUsers.contains(eventPageUserViewModel.userId) {
            eventStatus = .notGoing
        } else {
            eventStatus = .pending
        }

    }
}

struct CancelEventButton: View {
    @EnvironmentObject private var eventService: EventService
    @ObservedObject var eventViewModel: EventViewModel
    @Binding var showConfirmationDialog: Bool

    var body: some View {
        Button(action: {
            showConfirmationDialog = true
        }) {
            Text("Cancel Event")
                .font(.uiButton)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color.red)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.clear.opacity(0.25), lineWidth: 0)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.red.opacity(0.1)))
                )
        }
        .alert(isPresented: $showConfirmationDialog) {
            Alert(
                title: Text("Cancel Event"),
                message: Text("Are you sure you want to cancel this event?"),
                primaryButton: .destructive(Text("Cancel Event")) {
                    eventService.cancelEvent(id: eventViewModel.id)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct EventPageView_Previews: PreviewProvider {
    static func makeUserService() -> UserService {
        let userService = UserService()
        userService.user = mockUser
        return userService
    }

    static var previews: some View {
        let userService = makeUserService()
        let eventVM = EventViewModel(
            title: "Test event VM",
            datetime: Date(),
            location: "COM1",
            meetingPoint: "COM1",
            hostUser: (userService.user?.id)!
        )
        NavigationView {
            EventPageView(eventPageUserViewModel: EventPageUserViewModel(),
                          eventViewModel: eventVM)
                .environmentObject(userService)
        }
    }
}
