//
//  DatabaseAdapter.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 19/3/23.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class DatabaseAdapter: DatabaseConnector {
    //    private let databaseRef = Database.database().reference()
    private let encoder = JSONEncoder()

    func sendChatMessage(chatMessage: ChatMessage, chat: Chat) -> Bool {
        //        let databasePath = databaseRef.child("messages/\(chat.id)")
        //        do {
        //            let data = try encoder.encode(chatMessage)
        //            let json = try JSONSerialization.jsonObject(with: data)
        //            databasePath.child(chatMessage.id.uuidString).setValue(json)
        //        } catch {
        //            print("An error occurred", error)
        //            return false
        //        }
        return true
    }
}
