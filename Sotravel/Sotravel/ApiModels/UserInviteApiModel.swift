//
//  EventApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation

struct InviteApiModel: Codable {
    let id: Int
    let userID: String
    let inviteID: Int
    let createdAt: String
    let status, title: JSONNull?
    let details, date, time, location: String
    let meetingPoint, host, activity: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case inviteID = "invite_id"
        case createdAt = "created_at"
        case status, title, details, date, time, location
        case meetingPoint = "meeting_point"
        case host, activity
    }
}
