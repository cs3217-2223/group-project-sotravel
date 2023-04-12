import SwiftUI

struct EventPageView: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var chatService: ChatService
    @Environment(\.dismiss) var dismiss
    @ObservedObject var eventViewModel: EventViewModel
    @State private var selectedTab = 0
    @State private var showConfirmationDialog = false

    func makeTitle() -> some View {
        HStack {
            Text(eventViewModel.title)
                .font(.uiTitle2)
                .lineLimit(1)
            Spacer()
        }.padding(.bottom, 10)
    }

    func makeDate() -> some View {
        HStack {
            Image(systemName: "calendar")
                .imageScale(.medium)
                .symbolRenderingMode(.monochrome)
            Text(eventViewModel.datetime.toFriendlyDayTimeString())
                .font(.uiCallout)
        }
    }

    func makeLocation() -> some View {
        HStack {
            Image(systemName: "location.fill")
                .imageScale(.medium)
                .symbolRenderingMode(.monochrome)
            Text(eventViewModel.location)
                .font(.uiCallout)
        }
    }

    func makeMeetingPoint() -> some View {
        HStack {
            Image(systemName: "person.2.circle.fill")
                .imageScale(.medium)
                .symbolRenderingMode(.monochrome)
            Text("Meet at \(eventViewModel.meetingPoint)")
                .font(.uiCallout)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                makeTitle()
                makeDate()
                makeLocation()
                makeMeetingPoint()
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
                    EventStatusButton(eventViewModel: eventViewModel)
                }.padding(.top, 16)
                // Attendees status
                VStack {
                    HStack {
                        Text("Latest messages")
                            .font(.uiTitle3)
                        Spacer()
                    }

                    if chatService.chatPreviewVM.lastMessageVMs.isEmpty {
                        HStack {
                            Text("No messages yet!")
                                .font(.uiCallout)
                            Spacer()
                        }
                        .padding(.top, 3)
                        .padding(.bottom, 14)
                    } else {
                        VStack {
                            ForEach(chatService.chatPreviewVM.lastMessageVMs) { chatMessageVM in
                                ChatMessageView(chatMessageVM: chatMessageVM)
                                    .font(.body)
                                    .id(chatMessageVM.id.uuidString)
                            }
                        }
                        .padding(.top, 3)
                        .padding(.bottom, 14)
                    }

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
                        chatService.fetchChat(id: eventViewModel.id)
                    })
                    if let userId = userService.getUserId(), eventViewModel.hostUser == userId {
                        CancelEventButton(eventViewModel: eventViewModel, showConfirmationDialog: $showConfirmationDialog)
                            .padding(.top, 18)
                    }
                }
                .padding(.top, 18)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }.onAppear {
            chatService.getEventPagePreview(eventId: eventViewModel.id)
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

// struct EventPageView_Previews: PreviewProvider {
//    static func makeUserService() -> UserService {
//        let userService = UserService()
//        userService.user = mockUser
//        return userService
//    }
//
//    static var previews: some View {
//        let userService = makeUserService()
//        let eventVM = EventViewModel(
//            title: "Test event VM",
//            datetime: Date(),
//            location: "COM1",
//            meetingPoint: "COM1",
//            hostUser: (userService.user?.id)!
//        )
//        NavigationView {
//            EventPageView(eventPageUserViewModel: EventPageUserViewModel(),
//                          eventViewModel: eventVM)
//                .environmentObject(userService)
//        }
//    }
// }
