import SwiftUI

struct EventPageView: View {
    @ObservedObject var eventPageUserViewModel: EventPageUserViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var eventViewModel: EventViewModel
    var chat: Chat = mockChat
    @State private var selectedTab = 0
    @State private var eventStatus = EventStatus.pending

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                dismiss()
                            }
                        }
                        .padding(.trailing, 4)
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
                    EventStatusButton(eventStatus: $eventStatus)
                }.padding(.top, 16)

                // Attendees status
                VStack {
                    HStack {
                        Text("Latest messages")
                            .font(.uiTitle3)
                        Spacer()
                    }

                    VStack {
                        // Get latest 3 messages
                        ForEach(chat.messages.sorted { $0.timestamp > $1.timestamp }.prefix(3), id: \.id) {message in
                            ChatMessageView(chatMessage: message, isSentByMe: message.sender == eventPageUserViewModel.userId).font(.body)
                                .id(message.id)
                        }
                    }.padding(.top, 3)
                    .padding(.bottom, 14)

                    NavigationLink(destination: ChatView(chat: chat)) {
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
                    }
                }.padding(.top, 18)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }.navigationBarBackButtonHidden(true)
    }
}

struct EventPageView_Previews: PreviewProvider {
    static var previews: some View {
        let eventVM = EventViewModel(title: "Test event VM", datetime: Date(), location: "COM1", meetingPoint: "COM1")
        NavigationView {
            EventPageView(eventPageUserViewModel: EventPageUserViewModel(),
                          eventViewModel: eventVM,
                          chat: mockChat)
                .environmentObject(UserService())
        }
    }
}
