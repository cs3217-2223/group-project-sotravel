import Foundation
import CoreLocation

protocol DatabaseConnector {
    func sendChatMessage(chatMessage: ChatMessage, chat: Chat) -> Bool
}
