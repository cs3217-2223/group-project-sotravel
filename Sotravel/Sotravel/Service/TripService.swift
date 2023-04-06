//
//  TripService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import SwiftUI
import Resolver

class TripService: ObservableObject {

    @Published var selectedTapInCurrTrip: Int = 0
    @Published var trips: [Trip]
    private var selectedTrip: Trip?
    private var tripCache: [Int: Trip]

    @AppStorage("LastSelectedTripId") var lastSelectedTripId: Int?

    @Injected private var tripRepository: TripRepository

    init() {
        self.selectedTrip = nil
        self.tripCache = [:]
        self.trips = []
    }

    func getCurrTripId() -> Int? {
        selectedTrip?.id
    }

    func getTrip(from id: Int) -> Trip? {
        tripCache[id]
    }

    func getTripIds() -> [Int] {
        Array(tripCache.keys)
    }

    func resetTapIndex() {
        selectedTapInCurrTrip = 0
    }

    func loadUserTrips(userId: UUID, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    self.initCache(from: trips)
                    self.trips = trips
                    completion(true)
                }
            } catch {
                print("Error loading user trips:", error)
                completion(false)
            }
        }
    }

    func reloadUserTrips(userId: UUID, completion: @escaping () -> Void) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    self.updateCache(from: trips)
                    self.trips = trips
                    completion()
                }
            } catch {
                print("Error loading user events:", error)
            }
        }
    }

    func selectTrip(_ trip: Trip) {
        self.selectedTrip = trip
    }

    func getMostRecentTrip() -> Trip? {
        guard !trips.isEmpty else {
            return nil
        }

        let currentDate = Date()
        var mostRecentTrip = trips[0]
        var smallestTimeInterval = abs(currentDate.timeIntervalSince(mostRecentTrip.startDate))

        for trip in trips {
            let timeInterval = abs(currentDate.timeIntervalSince(trip.startDate))
            if timeInterval < smallestTimeInterval {
                smallestTimeInterval = timeInterval
                mostRecentTrip = trip
            }
        }

        return mostRecentTrip
    }

    func clear() {
        self.selectedTrip = nil
        self.tripCache = [:]
    }

    private func updateCache(from trips: [Trip]) {
        for trip in trips where tripCache[trip.id] == nil {
            tripCache[trip.id] = trip
        }
    }

    private func initCache(from trips: [Trip]) {
        for trip in trips {
            self.tripCache[trip.id] = trip
        }
    }
}
