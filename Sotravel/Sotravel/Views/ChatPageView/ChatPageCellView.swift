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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                Text(chatPageCellVM.chatTitle ?? "No Title")
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
                if let senderName = chatPageCellVM.lastMessageSender {
                    Text("\(senderName):")
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
}

// struct ChatPageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatPageCellView(chat: mockChat)
//    }
// }
