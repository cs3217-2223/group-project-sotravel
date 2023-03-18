//
//  ChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageView: View {
    @EnvironmentObject var eventsStore: EventsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("Chats")
                        .font(.uiTitle1)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 15)

                ForEach(self.eventsStore.events) { event in
                    NavigationLink(destination: ChatView(chat: mockChat)) {
                        ChatPageCellView(event: event, latestChatMessage: mockMessage1)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ChatPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageView()
            .environmentObject(mockUser)
            .environmentObject(EventsStore(events: mockEvents))
    }
}
