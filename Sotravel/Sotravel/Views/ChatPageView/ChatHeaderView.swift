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
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                    Text(getEventDatetime(eventId: chatHeaderVM.eventId))
                        .font(.uiSubheadline)
                }
                HStack {
                    Image(systemName: "person.2.circle.fill")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                    Text(getEventMeetingPoint(eventId: chatHeaderVM.eventId))
                        .font(.uiSubheadline)
                }
                if let eventVM = getEventVM(eventId: chatHeaderVM.eventId) {
                    NavigationLink(destination: EventPageView(eventViewModel: eventVM)) {
                        Text("View More").font(.uiFootnote).foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }.padding(.leading, 20)
    }

    private func getEventMeetingPoint(eventId: Int?) -> String {
        guard let eventId = eventId, let event = eventService.get(id: eventId) else {
            return "No meeting point"
        }
        return "Meet at \(event.meetingPoint)"
    }

    private func getEventTitle(eventId: Int?) -> String {
        guard let event = getEvent(eventId: eventId) else {
            return ""
        }
        return "\(event.title) at \(event.location)"
    }

    private func getEventDatetime(eventId: Int?) -> String {
        guard let event = getEvent(eventId: eventId) else {
            return ""
        }
        return event.datetime.toFriendlyDayTimeString()
    }

    private func getEventVM(eventId: Int?) -> EventViewModel? {
        guard let id = eventId else {
            return nil
        }
        return eventService.getEventViewModel(eventId: id)
    }

    private func getEvent(eventId: Int?) -> Event? {
        guard let eventId = eventId else {
            return nil
        }
        return eventService.get(id: eventId)
    }
}
