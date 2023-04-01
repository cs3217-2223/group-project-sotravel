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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
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
            HStack {
                if let senderId = chatPageCellVM.lastMessageSender {
                    // TODO: get sender name from userservice
                    Text("\(senderId):")
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
            // Handle nil case here
            return ""
        }
        return event.title
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

// struct ChatPageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatPageCellView(chat: mockChat)
//    }
// }
