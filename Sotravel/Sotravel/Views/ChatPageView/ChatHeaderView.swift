import SwiftUI

struct ChatHeaderView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var eventService: EventService
    @ObservedObject var chatHeaderVM: ChatHeaderViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 3) {
                Text(getEventTitle(eventId: chatHeaderVM.eventId))
                    .font(.uiButton)
                    .lineLimit(1)
                Text(getEventDatetime(eventId: chatHeaderVM.eventId))
                    .font(.uiSubheadline)
                    .lineLimit(1)
                if let eventVM = getEventVM(eventId: chatHeaderVM.eventId) {
                    NavigationLink(destination: EventPageView(eventViewModel: eventVM)) {
                        Text("View More").font(.uiFootnote).foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }.padding(.leading, 20)
    }

    private func getEventTitle(eventId: Int?) -> String {
        guard let event = getEvent(eventId: eventId) else {
            return ""
        }
        return event.title
    }

    private func getEventDatetime(eventId: Int?) -> String {
        guard let event = getEvent(eventId: eventId) else {
            return ""
        }
        return event.datetime.toFriendlyString()
    }

    private func getEventVM(eventId: Int?) -> EventViewModel? {
        guard let event = getEvent(eventId: eventId) else {
            return nil
        }
        return EventViewModel(event: event)
    }

    private func getEvent(eventId: Int?) -> Event? {
        guard let eventId = eventId else {
            return nil
        }
        return eventService.getEvent(id: eventId)
    }
}

// struct ChatHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatHeaderView(chat: mockChatNoEvent)
//        }
//    }
// }
