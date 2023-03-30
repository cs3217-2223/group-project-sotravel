import SwiftUI

class Chat: ObservableObject, Identifiable {
    var id: UUID
    @Published var title: String
    @Published var messages: [ChatMessage]
    @Published var members: [User]
    @Published var eventId: Int?

    init(id: UUID = UUID(), messages: [ChatMessage] = [ChatMessage](), title: String = "New Chat", members: [User]) {
        self.id = id
        self.messages = messages
        self.title = title
        self.members = members
    }

    init(id: UUID = UUID(), messages: [ChatMessage] = [ChatMessage](), title: String = "New Chat", members: [User], eventId: Int) {
        self.id = id
        self.messages = messages
        self.title = title
        self.members = members
        self.eventId = eventId
    }

    func addChatMessage(_ message: ChatMessage) {
        messages.append(message)
    }

    func isUserInChat(user: User) -> Bool {
        members.contains(user)
    }

    func getLatestMessage() -> ChatMessage? {
        messages.last
    }
}
