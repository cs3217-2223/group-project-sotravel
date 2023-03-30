//
//  TripService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import Foundation
import Resolver

class TripService: ObservableObject {
    @Published var selectedTrip: Trip?
    @Published var tripCache: [Int: Trip]

    @Injected private var tripRepository: TripRepository

    init() {
        self.selectedTrip = nil
        self.tripCache = [:]
    }

    func loadUserTrips(userId: UUID) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    self.initCache(from: trips)
                    self.objectWillChange.send()
                }
            } catch {
                print("Error loading user events:", error)
            }
        }
    }

    func selectTrip(_ trip: Trip) {
        self.selectedTrip = trip
    }

    func clear() {
        self.selectedTrip = nil
        self.tripCache = [:]
    }

    private func initCache(from trips: [Trip]) {
        for trip in trips {
            tripCache[trip.id] = trip
        }
    }
}
