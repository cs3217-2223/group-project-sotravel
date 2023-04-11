//
//  TripService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import SwiftUI
import Resolver

class TripService: BaseCacheService<Trip>, ObservableObject {
    @Published var selectedTapInCurrTrip: Int = 0
    @Published var trips: [Trip]

    private var selectedTrip: Trip?

    @AppStorage("LastSelectedTripId") var lastSelectedTripId: Int?

    @Injected private var tripRepository: TripRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.selectedTrip = nil
        self.trips = []
        super.init()
    }

    func getCurrTrip() -> Trip? {
        selectedTrip
    }

    func getCurrTripId() -> Int? {
        selectedTrip?.id
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
                serviceErrorHandler.handle(error)
                completion(false)
            }
        }
    }

    func reloadUserTrips(userId: UUID, completion: @escaping () -> Void) {
        Task {
            do {
                let trips = try await tripRepository.getTrips(userId: userId)
                DispatchQueue.main.async {
                    self.updateCacheInLoop(from: trips)
                    self.trips = trips
                    completion()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    func selectTrip(_ trip: Trip) {
        self.selectedTrip = trip
    }

    func clear() {
        self.selectedTrip = nil
        self.lastSelectedTripId = nil
        super.clearCache()
    }
}
