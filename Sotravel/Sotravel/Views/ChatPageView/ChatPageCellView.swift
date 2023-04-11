//
//  MessageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageCellView: View {
    @ObservedObject var chatPageCellVM: ChatPageCellViewModel
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var eventService: EventService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var friendService: FriendService
    @EnvironmentObject var viewAlertController: ViewAlertController

    private func makeTitle() -> some View {
        HStack(alignment: .center) {
            Text(getTitle(eventId: chatPageCellVM.id))
                .font(.uiHeadline)
                .foregroundColor(.primary)
                .clipped()
                .lineLimit(1)
            Spacer()
            Text(chatPageCellVM.lastMessageTimestamp ?? "")
                .font(.uiCaption1)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }

    private func makeDate() -> some View {
        HStack {
            Image(systemName: "calendar")
                .imageScale(.medium)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.primary)
            Text(getDate(eventId: chatPageCellVM.id))
                .font(.uiSubheadline)
                .foregroundColor(.primary)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            makeTitle()
            makeDate()
            HStack {
                if let senderId = chatPageCellVM.lastMessageSender {
                    Text("\(getSenderName(senderId: senderId)):")
                        .foregroundColor(.primary)
                        .opacity(0.8)
                } else {
                    Text("No Messages")
                        .foregroundColor(.primary)
                        .opacity(0.8)
                }
                Text(chatPageCellVM.lastMessageText ?? "")
                    .foregroundColor(.gray)
            }.font(Font.custom("Manrope-Regular", size: 14))
            .clipped()
            .padding(.top, 3)
            .lineLimit(1)

            Divider().padding(.top, 8)
        }
    }

    private func getTitle(eventId: Int?) -> String {
        guard let eventId = eventId, let event = eventService.getEvent(id: eventId) else {
            return "No event name"
        }
        return "\(event.title) at \(event.location)"
    }

    private func getDate(eventId: Int?) -> String {
        guard let eventId = eventId, let event = eventService.getEvent(id: eventId) else {
            return "No date"
        }
        return event.datetime.toFriendlyDayTimeString()
    }

    private func getSenderName(senderId: String) -> String {
        // sender is the user
        if let userId = chatService.userId, senderId == userId.uuidString {
            return userService.getUser()?.name ?? ""
        }

        // sender is a friend
        guard let senderUUID = UUID(uuidString: senderId) else {
            return ""
        }
        return friendService.getFriend(id: senderUUID)?.name ?? ""
    }
}

// struct ChatPageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatPageCellView(chat: mockChat)
//    }
// }
