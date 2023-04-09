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

    // Helper function to create a ChatPageCellView with the associated action
    private func chatCellView(chatPageCell: ChatPageCellViewModel) -> some View {
        NavigationLink(destination: ChatView()) {
            ChatPageCellView(chatPageCellVM: chatPageCell)
        }.simultaneousGesture(TapGesture().onEnded {
            self.chatService.fetchChat(id: chatPageCell.id)
        })
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Chats")
                        .font(.uiTitle1)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 4)

                if chatService.chatPageCellVMs.isEmpty {
                    Text("No chats yet. Chats for invites you are going to will be shown here 😊")
                        .font(.uiBody)
                        .foregroundColor(.gray)
                } else {
                    if sortedChatPageCellUpcomingViewModels().isEmpty {
                        HStack {
                            Text("No upcoming invites yet. Why not go create one? 😀")
                                .foregroundColor(.primary)
                                .font(.uiBody)
                            Spacer()
                        }
                    }
                    ForEach(sortedChatPageCellUpcomingViewModels()) { chatPageCell in
                        chatCellView(chatPageCell: chatPageCell)
                    }
                    Text("Past Invites")
                        .foregroundColor(.gray)
                        .font(.uiCaption1)
                        .padding(.vertical)
                    ForEach(sortedChatPageCellPastViewModels()) { chatPageCell in
                        chatCellView(chatPageCell: chatPageCell)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // Helper function to get ChatPageCellViewModels with associated events
    private func chatPageCellViewModelsWithEvents() -> [(ChatPageCellViewModel, Event)] {
        self.chatService.chatPageCellVMs
            .filter { $0.id != nil }
            .compactMap { vm -> (ChatPageCellViewModel, Event)? in
                if let event = eventService.getEvent(id: vm.id!) {
                    return (vm, event)
                } else {
                    return nil
                }
            }
    }

    // Get upcoming chatPageCellVMs
    private func sortedChatPageCellUpcomingViewModels() -> [ChatPageCellViewModel] {
        let viewModelsWithEvents = chatPageCellViewModelsWithEvents()
        let calendar = Calendar.current

        let upcomingViewModels = viewModelsWithEvents.filter { _, event in
            let eventDay = calendar.startOfDay(for: event.datetime)
            let today = calendar.startOfDay(for: Date())
            return eventDay >= today
        }

        // Sorted in asc order
        return upcomingViewModels
            .sorted(by: { $0.1.datetime < $1.1.datetime })
            .map { $0.0 } // Extract ChatPageCellViewModel from the sorted tuples
    }

    // Get past chatPageCellVMs
    private func sortedChatPageCellPastViewModels() -> [ChatPageCellViewModel] {
        let viewModelsWithEvents = chatPageCellViewModelsWithEvents()
        let calendar = Calendar.current

        let pastViewModels = viewModelsWithEvents.filter { _, event in
            let eventDay = calendar.startOfDay(for: event.datetime)
            let today = calendar.startOfDay(for: Date())
            return eventDay < today
        }

        // Sorted in desc order
        return pastViewModels
            .sorted(by: { $0.1.datetime > $1.1.datetime })
            .map { $0.0 } // Extract ChatPageCellViewModel from the sorted tuples
    }

}

struct ChatPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageView()
            .environmentObject(ChatService())
    }
}
