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
                Text(chatHeaderVM.chatTitle ?? "No Title")
                    .font(.uiButton)
                    .lineLimit(1)
                if let eventId = chatHeaderVM.eventId,
                   let event = eventService.eventCache[eventId],
                   let eventVM = eventService.eventToViewModels[event] {
                    Text(eventVM.datetime.toFriendlyString())
                        .font(.uiSubheadline)
                        .lineLimit(1)
                    NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel,
                                                              eventViewModel: eventVM)) {
                        Text("View More").font(.uiFootnote).foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }.padding(.leading, 20)
    }
}

// struct ChatHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatHeaderView(chat: mockChatNoEvent)
//        }
//    }
// }
