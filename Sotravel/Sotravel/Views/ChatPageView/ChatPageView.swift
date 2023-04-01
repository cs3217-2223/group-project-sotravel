//
//  ChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var eventService: EventService

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Chats")
                        .font(.uiTitle1)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 15)

                // TODO: if loading from trip page doesn't work can just load from here
                ForEach(self.chatService.chatPageCellVMs) { chatPageCell in
                    NavigationLink(destination: ChatView()) {
                        ChatPageCellView(chatPageCellVM: chatPageCell)
                    }.simultaneousGesture(TapGesture().onEnded {
                        self.chatService.fetchChat(id: chatPageCell.id)
                    })
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ChatPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageView()
            .environmentObject(ChatService())
    }
}
