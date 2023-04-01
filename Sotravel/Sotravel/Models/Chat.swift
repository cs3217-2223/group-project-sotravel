import SwiftUI

class Chat: ObservableObject, Identifiable {
    @Published var id: Int
    @Published var messages: [ChatMessage]

    init(id: Int, messages: [ChatMessage] = [ChatMessage]()) {
        self.id = id
        self.messages = messages
    }
}
