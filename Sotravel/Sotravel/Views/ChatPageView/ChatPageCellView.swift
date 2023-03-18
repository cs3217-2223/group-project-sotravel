//
//  MessageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageCellView: View {
    var chat: Chat
    var latestChatMessage: ChatMessage? {
        chat.getLatestMessage()
    }
    var timeStamp: String {
        guard let latestChatMessage = latestChatMessage else {
            return ""
        }
        return latestChatMessage.timestamp.isToday(using: calendar) ?
            latestChatMessage.timestamp.toFriendlyTimeString() :
            latestChatMessage.timestamp.toFriendlyDateString()
    }
    var senderName: String {
        guard let latestChatMessage = latestChatMessage else {
            return "No messages"
        }
        return "\(latestChatMessage.sender.name):"
    }
    var messageText: String {
        guard let latestChatMessage = latestChatMessage else {
            return ""
        }
        return latestChatMessage.messageText
    }
    var calendar = Calendar(identifier: .iso8601)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                Text(chat.title)
                    .font(.uiHeadline)
                    .foregroundColor(.black)
                    .clipped()
                    .lineLimit(1)
                Spacer()
                Text(timeStamp)
                    .font(.uiCaption1)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            HStack {
                Text(senderName)
                    .foregroundColor(.black)
                    .opacity(0.8)
                Text(messageText)
                    .foregroundColor(.gray)
            }.font(Font.custom("Manrope-Regular", size: 14))
            .clipped()
            .padding(.top, 3)
            .lineLimit(1)
            // Show latest message by

            Divider().padding(.top, 8)
        }
    }
}

struct ChatPageCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageCellView(chat: mockChat)
    }
}
