import Foundation

struct Trip: Identifiable {
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

    init(from apiModel: TripApiModel) {
        self.id = apiModel.id
        self.title = apiModel.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // TODO: Fix this default date issue
        self.startDate = dateFormatter.date(from: apiModel.startDate) ?? Date()
        self.endDate = dateFormatter.date(from: apiModel.endDate) ?? Date()
        self.location = apiModel.location
        // TODO: Remove force cast
        self.imageURL = URL(string: apiModel.mainImages[0])!
    }
}
