import Foundation

struct ChatMessage: Encodable {
    var id = UUID()

    let messageText: String
    let timestamp: Date
    let sender: UUID
}
