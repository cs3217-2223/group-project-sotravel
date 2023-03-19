import Foundation

struct ChatMessage: Encodable, Identifiable {
    var id = UUID()

    let messageText: String
    let timestamp: Date
    let sender: UUID
}
