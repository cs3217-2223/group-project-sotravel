//
//  TripService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import Foundation
import Resolver

class TripService: ObservableObject {

    @Published var selectedTapInCurrTrip: Int = 0
    private var selectedTrip: Trip?
    private var tripCache: [Int: Trip]

    @Injected private var tripRepository: TripRepository

    init() {
        self.selectedTrip = nil
        self.tripCache = [:]
    }

    func getCurrTripId() -> Int? {
        selectedTrip?.id
    }

    func getTripIds() -> [Int] {
        Array(tripCache.keys)
    }

    func getTrips() -> [Trip] {
        var res = Array(tripCache.values).sorted(by: { $0.startDate < $1.startDate })
        return res
    }

    func resetTapIndex() {
        selectedTapInCurrTrip = 0
    }

    func loadUserTrips(userId: UUID) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    print(trips)
                    self.initCache(from: trips)
                }
            } catch {
                print("Error loading user trips:", error)
            }
        }
    }

    func reloadUserTrips(userId: UUID) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    self.updateCache(from: trips)
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
