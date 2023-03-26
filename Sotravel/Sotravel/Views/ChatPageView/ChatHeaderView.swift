import SwiftUI

struct ChatHeaderView: View {
    @EnvironmentObject var chatService: ChatService
    @ObservedObject var chatHeaderVM: ChatHeaderViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.blue)
                .offset(y: chatHeaderVM.eventDatetime == nil ? 0 : -21)
                .onTapGesture {
                    withAnimation(.spring()) {
                        dismiss()
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(chatHeaderVM.chatTitle ?? "No Title")
                    .font(.uiButton)
                    .lineLimit(1)
                if let eventDatetime = chatHeaderVM.eventDatetime {
                    Text(eventDatetime.toFriendlyString())
                        .font(.uiSubheadline)
                        .lineLimit(1)
                    // TODO: link to event via idk
                    /*
                     NavigationLink(destination: EventPageView(eventPageUserViewModel: userService.eventPageViewModel,
                     eventViewModel: EventViewModel())) {
                     Text("View More")
                     .font(.uiFootnote)
                     .foregroundColor(.blue)
                     }
                     */
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
