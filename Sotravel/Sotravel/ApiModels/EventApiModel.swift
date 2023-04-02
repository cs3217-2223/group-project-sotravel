//
//  EventApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation

struct EventApiModel: Codable {
    let id: Int
    let tripId: Int
    let createdAt: String
    let status, details: String?
    let date, time, location: String
    let meetingPoint, host, activity: String
    let participants: Participants

    enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case createdAt = "created_at"
        case status, details, date, time, location
        case meetingPoint = "meeting_point"
        case host, activity, participants
    }
}

struct Participants: Codable {
    let going, no, pending: [String]
}
