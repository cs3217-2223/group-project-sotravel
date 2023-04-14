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

    func getTripViewModel(from trip: Trip) -> TripViewModel? {
        guard let trip = get(id: trip.id), let observer = observers[trip]?.first else {
            return nil
        }
        return observer as? TripViewModel
    }

    func getTripViewModels() -> [TripViewModel] {
        let allObservers = observers.values.flatMap { $0 }
        let triptViewModels = allObservers.compactMap { $0 as? TripViewModel }
        return triptViewModels
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
                    self.createTripCardViewModel(from: trips)
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

    func createTripCardViewModel(from trips: [Trip]) {
        for trip in trips {
            let viewModel = TripViewModel(trip: trip)
            self.addObserver(viewModel, for: trip)
        }
    }

    private func updateCacheAndViewModels(from trips: [Trip]) {
        for trip in trips {
            if self.get(id: trip.id) == nil {
                let viewModel = TripViewModel(trip: trip)
                self.addObserver(viewModel, for: trip)
            } else {
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
