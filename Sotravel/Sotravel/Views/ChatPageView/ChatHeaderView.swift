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
                NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel,
                                                          eventViewModel: getEventVM(eventId: chatHeaderVM.eventId))) {
                    Text("View More").font(.uiFootnote).foregroundColor(.blue)
                }
                //                if let eventId = chatHeaderVM.eventId,
                //                   let event = eventService.eventCache[eventId],
                //                   let eventVM = eventService.eventToViewModels[event] {
                //                    Text(eventVM.datetime.toFriendlyString())
                //                        .font(.uiSubheadline)
                //                        .lineLimit(1)
                //                    NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel,
                //                                                              eventViewModel: eventVM)) {
                //                        Text("View More").font(.uiFootnote).foregroundColor(.blue)
                //                    }
                //                }
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

    private func getEventVM(eventId: Int?) -> EventViewModel {
        guard let event = getEvent(eventId: eventId) else {
            return EventViewModel(event: mockEvent1) // TODO: handle this property
        }
        return EventViewModel(event: event)
    }

    /// If `nil` is returned, an error alert is already shown here
    private func getEvent(eventId: Int?) -> Event? {
        guard let eventId = eventId else {
            // TODO: show some alert
            print("chat not tied to event id")
            return nil
        }
        do {
            let event = try eventService.getEvent(id: eventId)
            return event
        } catch {
            // TODO: show some alert
            print("cannot get event")
            return nil
        }
    }
}

// struct ChatHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatHeaderView(chat: mockChatNoEvent)
//        }
//    }
// }
