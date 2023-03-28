import Foundation

let mockEvent1 = Event(
    title: "Climbing",
    // swiftlint:disable:next line_length
    details: "Join me for a fun day of rock climbing at Railay Beach, one of the most beautiful spots in Krabi. We'll explore the limestone cliffs and try some challenging routes, all while enjoying the stunning views of the ocean. No prior climbing experience necessary!",
    status: "Idk?",
    datetime: Date(timeIntervalSinceNow: 3_600),
    meetingPoint: "Hotel Lobby",
    location: "Railay Beach, Krabi",
    hostUser: mockUser.id,
    invitedUsers: mockFriendss.map { $0.id } + [mockUser.id],
    attendingUsers: [mockFriendss[1]].map { $0.id } + [mockUser.id],
    rejectedUsers: [mockFriendss[2]].map { $0.id }
)

let mockEvent2 = Event(
    title: "Hike",
    // swiftlint:disable:next line_length
    details: "Let's hike up to the Tiger Cave Temple, a beautiful and peaceful Buddhist temple located at the top of a hill. The climb is steep, but the views from the top are breathtaking. Don't forget to bring your camera!",
    status: "Idk?",
    datetime: Date(timeIntervalSinceNow: 7_200),
    meetingPoint: "Taxi Stand beside Hostel",
    location: "Tiger Cave Temple, Krabi",
    hostUser: mockFriendss[1].id,
    invitedUsers: mockFriendss.map { $0.id },
    attendingUsers: [mockFriendss[1], mockFriendss[3]].map { $0.id },
    rejectedUsers: [mockFriendss[0]].map { $0.id }
)

let mockEvent3 = Event(
    title: "Island Hopping",
    // swiftlint:disable:next line_length
    details: "Join me for a day of island hopping at the stunning Phi Phi Islands. We'll visit several beautiful beaches and snorkel in the crystal-clear waters. Lunch will be provided on the boat, and we'll end the day with a beautiful sunset view.",
    status: "Idk?",
    datetime: Calendar.current.date(byAdding: DateComponents(day: -1), to: Date()) ?? Date(), // Set the event date to yesterday
    meetingPoint: "Coffee Shop beside Hostel",
    location: "Phi Phi Islands, Krabi",
    hostUser: mockFriendss[4].id,
    invitedUsers: mockFriendss.map { $0.id } + [mockUser.id],
    attendingUsers: [mockFriendss[4], mockFriendss[5]].map { $0.id },
    rejectedUsers: []
)

let mockEvent4 = Event(
    title: "Skinny Dip",
    // swiftlint:disable:next line_length
    details: "Let's take a dip in the beautiful Emerald Pool, a natural swimming pool surrounded by lush jungle. We'll hike through the forest and enjoy the serene surroundings before cooling off in the refreshing water.",
    status: "Idk?",
    datetime: Calendar.current.date(byAdding: DateComponents(day: +1), to: Date()) ?? Date(), // Set the event date to tomorrow
    meetingPoint: "Room 6B in Hostel",
    location: "Emerald Pool, Krabi",
    hostUser: mockFriendss[2].id,
    invitedUsers: mockFriendss.map { $0.id } + [mockUser.id],
    attendingUsers: [mockFriendss[2]].map { $0.id },
    rejectedUsers: []
)

//
// let mockEvent4 = Event(
//    activity: "Skinny Dip",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockFriends[2]],
//    rejectedUsers: [mockFriends[1]],
//    datetime: Date(timeIntervalSinceNow: 14_400),
//    location: "Emerald Pool, Krabi",
//    meetingPoint: "Room 6B in Hostel",
//    // swiftlint:disable:next line_length
//    description: "Let's take a dip in the beautiful Emerald Pool, a natural swimming pool surrounded by lush jungle. We'll hike through the forest and enjoy the serene surroundings before cooling off in the refreshing water.",
//    hostUser: mockFriends[2]
// )
//
// let mockEvent5 = Event(
//    activity: "Beach Volley Ball",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockFriends[0], mockFriends[1], mockFriends[2]],
//    rejectedUsers: [mockFriends[3]],
//    datetime: Date(timeIntervalSinceNow: 18_000),
//    location: "Ao Nang Beach, Krabi",
//    meetingPoint: "Hotel Lobby",
//    // swiftlint:disable:next line_length
//    description: "Let's play some beach volleyball at beautiful Ao Nang Beach! We'll set up a net and enjoy some friendly competition on the sand. All skill levels welcome.",
//    hostUser: mockFriends[0]
// )
//
// let mockEvent6 = Event(
//    activity: "Kayaking",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockUser, mockFriends[3], mockFriends[4], mockFriends[5]],
//    rejectedUsers: [],
//    datetime: Date(timeIntervalSinceNow: 21_600),
//    location: "Hong Island, Krabi",
//    meetingPoint: "Hotel Lobby",
//    // swiftlint:disable:next line_length
//    description: "Let's explore the beautiful Hong Island on a kayaking adventure! We'll paddle through stunning lagoons and caves, and take in the natural beauty of this hidden gem. Lunch will be provided on the beach.",
//    hostUser: mockUser
// )
//
// let mockEvent7 = Event(
//    activity: "Scenic Hike",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockUser, mockFriends[2], mockFriends[4]],
//    rejectedUsers: [mockFriends[0]],
//    datetime: Date(timeIntervalSinceNow: 25_200),
//    location: "Thung Teao Forest Natural Park, Krabi",
//    meetingPoint: "Hotel Lobby",
//    // swiftlint:disable:next line_length
//    description: "Let's go for a scenic hike in the beautiful Thung Teao Forest Natural Park. We'll explore the lush rainforest and take a dip in the stunning Crystal Pool. Don't forget your hiking boots!",
//    hostUser: mockUser
// )
//
// let mockEvent8 = Event(
//    activity: "Makan",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockUser, mockFriends[1], mockFriends[3], mockFriends[4]],
//    rejectedUsers: [mockFriends[2]],
//    datetime: Date(timeIntervalSinceNow: 28_800),
//    location: "Krabi Town Night Market, Krabi",
//    meetingPoint: "Hotel Lobby",
//    // swiftlint:disable:next line_length
//    description: "Let's explore the vibrant night market in Krabi Town! We'll sample delicious street food, browse local crafts and souvenirs, and soak up the lively atmosphere of this bustling market.",
//    hostUser: mockUser
// )
//
// let mockEvent9 = Event(
//    activity: "Unwind",
//    invitedUsers: mockFriends,
//    attendingUsers: [mockUser, mockFriends[0], mockFriends[2], mockFriends[5]],
//    rejectedUsers: [],
//    datetime: Date(timeIntervalSinceNow: 32_400),
//    location: "Krabi Hot Springs, Krabi",
//    meetingPoint: "Hotel Lobby",
//    // swiftlint:disable:next line_length
//    description: "Let's unwind and relax at the beautiful Krabi Hot Springs. We'll soak in the natural pools and take in the tranquil surroundings of this hidden gem. Don't forget your swimsuit and towel!",
//    hostUser: mockUser
// )

let mockEvents = [mockEvent1,
                  mockEvent2,
                  mockEvent3,
                  mockEvent4]
// mockEvent4, mockEvent5, mockEvent6, mockEvent7, mockEvent8, mockEvent9]
