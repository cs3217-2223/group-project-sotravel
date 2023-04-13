//
//  TripRepositoryNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 28/3/23.
//

import Foundation
import Resolver
import Combine

class TripRepositoryNode: TripRepository {
    @Injected private var userRepository: UserRepository
    private static var api = NodeApi()

    func getTrips(userId: UUID) async throws -> [Trip] {
        let params = ["user_id": userId.uuidString]
        let (status, response) = try await Self.api.get(path: .userTrips, params: params)

        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)
        let allTrips: AllTrips = try DecoderHelper.decodeToClass(data: data)

        return allTrips.pastTrips + allTrips.upcomingTrips
    }

    func getAllUsersOnTrip(tripId: Int) async throws -> [User] {
        let params = ["trip_id": String(tripId)]
        let (status, response) = try await Self.api.get(path: .friends, params: params)
        try ApiErrorHelper.handleError(status: status)
        let data = try ApiErrorHelper.handleNilResponse(data: response)

        do {
            let friendIds = try JSONDecoder().decode([String].self, from: Data(data.utf8))
            let results: [User] = []

            return try await withThrowingTaskGroup(of: (User?).self) {group in
                for id in friendIds {
                    guard let idAsUUID = UUID(uuidString: id) else {
                        continue
                    }
                    group.addTask { try await self.userRepository.get(id: idAsUUID) }
                }

                return try await group.reduce(into: results) {acc, curr in
                    if let curr = curr {
                        acc.append(curr)
                    }
                }
            }
        } catch is DecodingError {
            throw SotravelError.DecodingError("Unable to parse Get Friends response")
        } catch {
            throw error
        }
    }
}
