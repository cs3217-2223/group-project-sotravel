//
//  TripRepositoryNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 28/3/23.
//

import Foundation

class TripRepositoryNode: TripRepository {
    private static var api = NodeApi()

    func getTrips(userId: UUID) async throws -> [Trip] {
        let params = ["user_id": userId.uuidString]
        let (status, response) = try await TripRepositoryNode.api.get(path: .userTrips,
                                                                      params: params)
        let functionName = "Get Trip"

        try ApiErrorHelper.handleError(location: functionName, status: status)
        let data = try ApiErrorHelper.handleNilResponse(location: functionName, data: response)
        let allTrips: AllTrips = try DecoderHelper.decodeToClass(functionName: functionName, data: data)

        return allTrips.pastTrips + allTrips.upcomingTrips
    }
}
