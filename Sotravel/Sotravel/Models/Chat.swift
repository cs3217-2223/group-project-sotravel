import SwiftUI

class Chat: Identifiable {
    var id = UUID()
    var title: String
    var messages: [ChatMessage]
    var members: [User]
    var event: Event?

    init(messages: [ChatMessage] = [ChatMessage](), title: String = "New Chat", members: [User]) {
        self.messages = messages
        self.title = title
        self.members = members
    }

    init(messages: [ChatMessage] = [ChatMessage](), members: [User], event: Event) {
        self.messages = messages
        self.title = event.title
        self.members = members
        self.event = event
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
