//
//  TripCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol TripRepository {
    func getTrips(userId: UUID) async throws -> [Trip]
    func getAllFriendsOnTrip(tripId: Int) async throws -> [User]
}

class TripRepositoryStub: TripRepository {
    func getTrips(userId: UUID) async throws -> [Trip] {
        mockTrips
    }

    func getAllFriendsOnTrip(tripId: Int) async throws -> [User] {
        mockFriends
    }
}
