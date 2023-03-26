//
//  Invite.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation

struct Invite: Codable {
    let id: Int
    let userID: String
    let inviteID: Int
    let status: String?
    let details, date, time, location: String
    let meetingPoint, host, activity: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case inviteID = "invite_id"
        case status, details, date, time, location
        case meetingPoint = "meeting_point"
        case host, activity
    }

    init(apiModel: UserInviteApiModel) {
        self.id = apiModel.id
        self.userID = apiModel.userID
        self.inviteID = apiModel.inviteID
        self.status = apiModel.status
        self.details = apiModel.details
        self.date = apiModel.date
        self.time = apiModel.time
        self.location = apiModel.location
        self.meetingPoint = apiModel.meetingPoint
        self.host = apiModel.host
        self.activity = apiModel.activity
    }
}
