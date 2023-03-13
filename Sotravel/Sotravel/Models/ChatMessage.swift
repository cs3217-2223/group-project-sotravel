import Foundation

struct ChatMessage {
    let messageText: String
    let timestamp: Date
    let sender: User
}

struct Chat {
    let messages: [ChatMessage]
}
