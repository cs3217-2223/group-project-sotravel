//
//  UserCreateEventApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation

struct UserCreateEventApiModel: Codable {
    let details: String?
    let activity, date, time: String
    let location, meetingPoint: String
    let sendToUserIDS: [String]

    enum CodingKeys: String, CodingKey {
        case activity, details, date, time, location
        case meetingPoint = "meeting_point"
        case sendToUserIDS = "send_to_user_ids"
    }

    init(from event: Event) {
        self.activity = event.title
        self.details = event.details
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: event.datetime)
        dateFormatter.dateFormat = "h:mm a"
        self.time = dateFormatter.string(from: event.datetime)

        self.location = event.location
        self.meetingPoint = event.meetingPoint
        self.sendToUserIDS = event.invitedUsers.map { $0.uuidString }
    }
}
