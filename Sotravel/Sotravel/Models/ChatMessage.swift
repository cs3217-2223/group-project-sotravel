import Foundation

struct ChatMessage {
    var id = UUID()

    let messageText: String
    let timestamp: Date
    let sender: User
}
