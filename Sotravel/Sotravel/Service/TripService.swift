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
    @Published var tripViewModels: [TripViewModel]

    private var selectedTrip: Trip?
    private var tripToTripViewModel: [Trip: TripViewModel]

    @AppStorage("LastSelectedTripId") var lastSelectedTripId: Int?

    @Injected private var tripRepository: TripRepository
    @Injected private var serviceErrorHandler: ServiceErrorHandler

    override init() {
        self.selectedTrip = nil
        self.tripViewModels = []
        self.tripToTripViewModel = [:]
        super.init()
    }

    func getTripViewModel(from trip: Trip) -> TripViewModel? {
        tripToTripViewModel[trip]
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
            self.tripViewModels.append(viewModel)
            self.tripToTripViewModel[trip] = viewModel
        }
    }

    private func updateCacheAndViewModels(from trips: [Trip]) {
        for trip in trips where get(id: trip.id) == nil {
            updateCache(from: trip)
            let viewModel = TripViewModel(trip: trip)
            self.tripViewModels.append(viewModel)
            self.tripToTripViewModel[trip] = viewModel
        }
    }

    func selectTrip(_ trip: Trip) {
        self.selectedTrip = trip
    }

    func clear() {
        self.selectedTrip = nil
        self.lastSelectedTripId = nil
        self.tripToTripViewModel = [:]
        self.tripViewModels = []
        super.clearCache()
    }
}
