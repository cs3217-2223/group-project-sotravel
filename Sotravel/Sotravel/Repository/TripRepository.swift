//
//  TripCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol TripRepository {
    func getTrips(userId: UUID) async throws -> [Trip]
}
