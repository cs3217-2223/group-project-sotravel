import Foundation

let mockEvent1 = Event(
    title: "Climbing at Railay",
    invitedUsers: mockFriends,
    attendingUsers: mockFriends,
    rejectedUsers: [mockFriends[2]],
    datetime: Date(timeIntervalSinceNow: 3_600),
    location: "Railay Beach, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Join me for a fun day of rock climbing at Railay Beach, one of the most beautiful spots in Krabi. We'll explore the limestone cliffs and try some challenging routes, all while enjoying the stunning views of the ocean. No prior climbing experience necessary!",
    hostUser: mockUser
)

let mockEvent2 = Event(
    title: "Hike up Tiger Cave Temple",
    invitedUsers: mockFriends,
    attendingUsers: [mockFriends[1], mockFriends[3]],
    rejectedUsers: [mockFriends[0]],
    datetime: Date(timeIntervalSinceNow: 7_200),
    location: "Tiger Cave Temple, Krabi",
    meetingPoint: "Taxi Stand beside Hostel",
    // swiftlint:disable:next line_length
    description: "Let's hike up to the Tiger Cave Temple, a beautiful and peaceful Buddhist temple located at the top of a hill. The climb is steep, but the views from the top are breathtaking. Don't forget to bring your camera!",
    hostUser: mockFriends[1]
)

let mockEvent3 = Event(
    title: "Island Hopping at Phi Phi Islands",
    invitedUsers: mockFriends,
    attendingUsers: [mockFriends[4], mockFriends[5]],
    rejectedUsers: [],
    datetime: Date(timeIntervalSinceNow: 10_800),
    location: "Phi Phi Islands, Krabi",
    meetingPoint: "Coffee Shop beside Hostel",
    // swiftlint:disable:next line_length
    description: "Join me for a day of island hopping at the stunning Phi Phi Islands. We'll visit several beautiful beaches and snorkel in the crystal-clear waters. Lunch will be provided on the boat, and we'll end the day with a beautiful sunset view.",
    hostUser: mockFriends[4]
)

let mockEvent4 = Event(
    title: "Skinny Dip at Emerald Pool",
    invitedUsers: mockFriends,
    attendingUsers: [mockFriends[2]],
    rejectedUsers: [mockFriends[1]],
    datetime: Date(timeIntervalSinceNow: 14_400),
    location: "Emerald Pool, Krabi",
    meetingPoint: "Room 6B in Hostel",
    // swiftlint:disable:next line_length
    description: "Let's take a dip in the beautiful Emerald Pool, a natural swimming pool surrounded by lush jungle. We'll hike through the forest and enjoy the serene surroundings before cooling off in the refreshing water.",
    hostUser: mockFriends[2]
)

let mockEvent5 = Event(
    title: "Beach Volley Ball at Ao Nang Beach",
    invitedUsers: mockFriends,
    attendingUsers: [mockFriends[0], mockFriends[1], mockFriends[2]],
    rejectedUsers: [mockFriends[3]],
    datetime: Date(timeIntervalSinceNow: 18_000),
    location: "Ao Nang Beach, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Let's play some beach volleyball at beautiful Ao Nang Beach! We'll set up a net and enjoy some friendly competition on the sand. All skill levels welcome.",
    hostUser: mockFriends[0]
)

let mockEvent6 = Event(
    title: "Kayaking at Hong Island",
    invitedUsers: mockFriends,
    attendingUsers: [mockUser, mockFriends[3], mockFriends[4], mockFriends[5]],
    rejectedUsers: [],
    datetime: Date(timeIntervalSinceNow: 21_600),
    location: "Hong Island, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Let's explore the beautiful Hong Island on a kayaking adventure! We'll paddle through stunning lagoons and caves, and take in the natural beauty of this hidden gem. Lunch will be provided on the beach.",
    hostUser: mockUser
)

let mockEvent7 = Event(
    title: "Scenic Hike at Thung Teao Forest Natural Park",
    invitedUsers: mockFriends,
    attendingUsers: [mockUser, mockFriends[2], mockFriends[4]],
    rejectedUsers: [mockFriends[0]],
    datetime: Date(timeIntervalSinceNow: 25_200),
    location: "Thung Teao Forest Natural Park, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Let's go for a scenic hike in the beautiful Thung Teao Forest Natural Park. We'll explore the lush rainforest and take a dip in the stunning Crystal Pool. Don't forget your hiking boots!",
    hostUser: mockUser
)

let mockEvent8 = Event(
    title: "Makan at Krabi Town Night Market",
    invitedUsers: mockFriends,
    attendingUsers: [mockUser, mockFriends[1], mockFriends[3], mockFriends[4]],
    rejectedUsers: [mockFriends[2]],
    datetime: Date(timeIntervalSinceNow: 28_800),
    location: "Krabi Town Night Market, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Let's explore the vibrant night market in Krabi Town! We'll sample delicious street food, browse local crafts and souvenirs, and soak up the lively atmosphere of this bustling market.",
    hostUser: mockUser
)

let mockEvent9 = Event(
    title: "Unwind at Krabi Hot Springs",
    invitedUsers: mockFriends,
    attendingUsers: [mockUser, mockFriends[0], mockFriends[2], mockFriends[5]],
    rejectedUsers: [],
    datetime: Date(timeIntervalSinceNow: 32_400),
    location: "Krabi Hot Springs, Krabi",
    meetingPoint: "Hotel Lobby",
    // swiftlint:disable:next line_length
    description: "Let's unwind and relax at the beautiful Krabi Hot Springs. We'll soak in the natural pools and take in the tranquil surroundings of this hidden gem. Don't forget your swimsuit and towel!",
    hostUser: mockUser
)

// swiftlint:disable:next line_length
let mockEvents = [mockEvent1, mockEvent2, mockEvent3, mockEvent4, mockEvent5, mockEvent6, mockEvent7, mockEvent8, mockEvent9]
