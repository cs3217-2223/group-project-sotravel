//
//  TripService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 30/3/23.
//

import SwiftUI
import Resolver

class TripService: BaseCacheService<Trip>, ObservableObject, Subject {
    typealias ObservedData = Trip
    typealias ObserverProtocol = TripObserver

    @Published var selectedTapInCurrTrip: Int = 0

    internal var observers: [ObservedData: [ObserverProtocol]]

    private var selectedTrip: Trip?

    @AppStorage("LastSelectedTripId") var lastSelectedTripId: Int?

    @Injected private var tripRepository: TripRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.selectedTrip = nil
        self.observers = [:]
        super.init()
    }

    func getTripViewModel(from tripId: Int) -> TripViewModel? {
        guard let trip = get(id: tripId) else {
            return nil
        }

        if let existingViewModel = self.getObservers(for: trip)?.compactMap({ $0 as? TripViewModel }).first {
            return existingViewModel
        } else {
            let newViewModel = TripViewModel(trip: trip)
            self.addObserver(newViewModel, for: trip)
            return newViewModel
        }
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
                    self.objectWillChange.send()
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
                    self.updateCacheAndViewModels(from: trips)
                    self.objectWillChange.send()
                    completion()
                }
            } catch {
                serviceErrorHandler.handle(error)
            }
        }
    }

    private func updateCacheAndViewModels(from trips: [Trip]) {
        for trip in trips {
            if self.get(id: trip.id) != nil {
                self.notifyAll(for: trip)
            }
            updateCache(from: trip)
        }
    }

    func selectTrip(_ trip: Trip) {
        self.selectedTrip = trip
    }

    func clear() {
        self.selectedTrip = nil
        self.lastSelectedTripId = nil
        self.observers = [:]
        super.clearCache()
    }
}
