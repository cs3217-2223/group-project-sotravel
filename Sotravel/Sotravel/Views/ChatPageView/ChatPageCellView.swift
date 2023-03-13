//
//  MessageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageCellView: View {
    var event: Event
    var latestChatMessage: ChatMessage
    var calendar = Calendar(identifier: .iso8601)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                Text(event.title)
                    .font(.uiHeadline)
                    .foregroundColor(.black)
                    .clipped()
                    .lineLimit(1)
                Spacer()
                Text(
                    latestChatMessage.timestamp.isToday(using: calendar) ?
                        latestChatMessage.timestamp.toFriendlyTimeString() :
                        latestChatMessage.timestamp.toFriendlyDateString())
                    .font(.uiCaption1)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            HStack {
                Text("\(latestChatMessage.sender.name):")
                    .foregroundColor(.black)
                    .opacity(0.8)
                Text(latestChatMessage.messageText)
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
        ChatPageCellView(event: mockEvent1, latestChatMessage: mockMessage1)
    }
}
