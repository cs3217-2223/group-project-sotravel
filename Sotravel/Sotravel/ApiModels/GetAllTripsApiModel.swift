//
//  GetAllTripsApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 28/3/23.
//

import Foundation

struct GetAllTripsApiModel: Codable {
    let upcomingTrips, pastTrips: [TripApiModel]
}

// MARK: - Trip
struct TripApiModel: Codable {
    let id: Int
    let name, startDate, endDate, location: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case location, imageURL
    }
}
