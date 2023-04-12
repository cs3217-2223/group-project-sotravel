import SwiftUI

enum EventStatus {
    case pending
    case going
    case notGoing
}

struct EventStatusButton: View {
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var eventService: EventService
    @EnvironmentObject private var chatService: ChatService
    @ObservedObject var eventViewModel: EventViewModel
    @State private var isMenuVisible = false

    var body: some View {
        if let userId = userService.getUserId() {
            Group {
                if eventViewModel.hostUser == userId {
                    Text("You're hosting 😊")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.purple)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.purple, lineWidth: 2)
                        )
                        .cornerRadius(10)
                } else {
                    Menu {
                        Button(action: {
                            eventViewModel.eventStatus = .going
                            eventService.rsvpToEvent(eventId: eventViewModel.id,
                                                     userId: userId,
                                                     status: EventRsvpStatus.yes)
                            chatService.fetchChatPageCell(id: eventViewModel.id)
                        }, label: {
                            Label("Going", systemImage: "checkmark.circle.fill")
                        })
                        Button(action: {
                            eventViewModel.eventStatus = .notGoing
                            eventService.rsvpToEvent(eventId: eventViewModel.id,
                                                     userId: userId,
                                                     status: EventRsvpStatus.no)
                            chatService.removeChatPageCell(id: eventViewModel.id)
                        }, label: {
                            Label("Not Going", systemImage: "xmark.circle.fill")
                        })
                        if eventViewModel.eventStatus == .pending {
                            Button(action: {
                                eventViewModel.eventStatus = .pending
                            }, label: {
                                Label("Pending", systemImage: "clock")
                            })
                        }
                    } label: {
                        HStack {
                            Text(statusString)
                                .foregroundColor(statusColor)
                                .font(.headline)
                            Image(systemName: "chevron.down")
                                .foregroundColor(statusColor)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(statusColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(statusColor, lineWidth: 2)
                        )
                        .cornerRadius(10)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                }
            }
        } else {
            // Handle case where userId is nil
            EmptyView()
        }
    }

    var statusString: String {
        switch eventViewModel.eventStatus {
        case .pending:
            return "Are you going?"
        case .going:
            return "Going"
        case .notGoing:
            return "Not Going"
        }
    }

    var statusColor: Color {
        switch eventViewModel.eventStatus {
        case .pending:
            return Color.uiPrimary
        case .going:
            return Color.green
        case .notGoing:
            return Color.red
        }
    }
}
