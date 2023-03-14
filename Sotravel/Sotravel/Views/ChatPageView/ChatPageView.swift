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
                ForEach(self.eventsStore.events) { event in
                    NavigationLink(destination: GroupChatView(event: event, chat: mockChat)) {
                        ChatPageCellView(event: event, latestChatMessage: mockMessage1)
                    }
                }
            }
            .navigationTitle("Chats")
            .padding(.all)
        }
    }
}

struct ChatPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageView().environmentObject(EventsStore(events: mockEvents))
    }
}
