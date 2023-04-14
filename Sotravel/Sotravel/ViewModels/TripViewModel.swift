//
//  TripCardViewModel.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/4/23.
//

import Foundation

class TripViewModel: TripObserver, ObservableObject {
    @Published var id: Int
    @Published var title: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var location: String
    @Published var imageURL: URL?

    init(id: Int = .zero,
         title: String = "",
         startDate: Date = Date(),
         endDate: Date = Date(),
         location: String = "",
         imageURL: URL? = URL(string: "")) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.imageURL = imageURL
    }

    init(trip: Trip) {
        self.id = trip.id
        self.title = trip.title
        self.startDate = trip.startDate
        self.endDate = trip.endDate
        self.location = trip.location
        self.imageURL = trip.imageURL
    }

    override func updateFrom(data: Trip) {
        self.id = data.id
        self.title = data.title
        self.startDate = data.startDate
        self.endDate = data.endDate
        self.location = data.location
        self.imageURL = data.imageURL
    }

    override func clear() {
        self.id = .zero
        self.title = ""
        self.startDate = Date()
        self.endDate = Date()
        self.location = ""
        self.imageURL = nil
    }
}
