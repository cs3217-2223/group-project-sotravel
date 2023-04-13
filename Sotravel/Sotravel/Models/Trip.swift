import Foundation

class AllTrips: ConvertableFromApiModel {
    let upcomingTrips, pastTrips: [Trip]

    required init(apiModel: GetAllTripsApiModel) {
        upcomingTrips = apiModel.upcomingTrips.map { Trip(apiModel: $0) }
        pastTrips = apiModel.pastTrips.map { Trip(apiModel: $0) }
    }

}

class Trip: Hashable, Identifiable, ConvertableFromApiModel {
    let id: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
    let imageURL: URL

    init(id: Int, title: String, startDate: Date, endDate: Date, location: String, imageURL: URL) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.imageURL = imageURL
    }

    required init(apiModel: TripApiModel) {
        self.id = apiModel.id
        self.title = apiModel.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // TODO: Fix this default date issue
        self.startDate = dateFormatter.date(from: apiModel.startDate) ?? Date()
        self.endDate = dateFormatter.date(from: apiModel.endDate) ?? Date()
        self.location = apiModel.location
        // TODO: Remove force cast
        self.imageURL = URL(string: apiModel.imageURL)!
    }

    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
