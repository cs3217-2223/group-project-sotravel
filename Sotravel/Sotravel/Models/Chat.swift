import SwiftUI

class Chat: ObservableObject, Identifiable {
    var idUUID: UUID
    var id: Int
    @Published var title: String
    @Published var messages: [ChatMessage]
    @Published var members: [User]
    @Published var eventId: Int? // TODO: rename to id, just keep 1 of id and eventid

    init(id: Int, messages: [ChatMessage] = [ChatMessage]()) {
        self.eventId = id
        self.messages = messages
        self.id = id

        self.title = ""
        self.idUUID = UUID()
        self.members = []
    }

    init(id: UUID = UUID(), messages: [ChatMessage] = [ChatMessage](), title: String = "New Chat", members: [User]) {
        self.idUUID = id
        self.messages = messages
        self.title = title
        self.members = members
        self.id = -1
    }

    init(id: UUID = UUID(), messages: [ChatMessage] = [ChatMessage](), title: String = "New Chat", members: [User], eventId: Int) {
        self.idUUID = id
        self.messages = messages
        self.title = title
        self.members = members
        self.eventId = eventId
        self.id = -1
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
