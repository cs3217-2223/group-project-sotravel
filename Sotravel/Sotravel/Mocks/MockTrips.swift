import Foundation

let mockTrips = [
    Trip(
        title: "Beach Vacation",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86_400 * 7),
        location: "Phuket, Thailand",
        imageURL: URL(string: "https://images.unsplash.com/photo-1589394815804-964ed0be2eb5?" +
                        "ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGh1a2V0fGVufDB8fDB8fA%3D%3D&" +
                        "auto=format&fit=crop&w=800&q=60")!
    ),
    Trip(
        title: "Mountain Retreat",
        startDate: Date().addingTimeInterval(86_400 * 8),
        endDate: Date().addingTimeInterval(86_400 * 14),
        location: "Nepal",
        imageURL: URL(string: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?" +
                        "ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&" +
                        "auto=format&fit=crop&w=2342&q=80")!
    ),
    Trip(
        title: "Great Singapore Ski Trip",
        startDate: Date().addingTimeInterval(86_400 * 15),
        endDate: Date().addingTimeInterval(86_400 * 21),
        location: "France",
        imageURL: URL(string: "https://images.unsplash.com/photo-1459196088695-2eef93d1c69c?" +
                        "ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8c2tpJTIwZnJhbmNlfGVufDB8fDB8fA%3D%3D&" +
                        "auto=format&fit=crop&w=800&q=60")!
    )
]
