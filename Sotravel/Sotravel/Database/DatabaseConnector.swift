import Foundation
import CoreLocation

protocol DatabaseConnector {
    func sendChatMessage(chatMessage: ChatMessage, chat: Chat) -> Bool
    func listenForFriendsLocations(completion: @escaping ([String: CLLocation]) -> Void)
    func updateCurrentUserLocation(_ location: CLLocation, userId: String)
}
