//
//  TripCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol TripRepository {
    func getTrips(userId: UUID) async throws -> [Trip]
    func getAllUsersOnTrip(tripId: Int) async throws -> [UUID]
}

class TripRepositoryStub: TripRepository {
    func getTrips(userId: UUID) async throws -> [Trip] {
        mockTrips
    }

    func getAllUsersOnTrip(tripId: Int) async throws -> [UUID] {
        mockFriends.map({ $0.id })
    }
}
