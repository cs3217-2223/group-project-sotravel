import Foundation

struct Trip: Identifiable {
    let id = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
    let imageURL: URL
}
