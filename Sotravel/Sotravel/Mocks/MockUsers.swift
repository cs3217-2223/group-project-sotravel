import Foundation

let mockUser = User(
    id: UUID(),
    firstName: "Larry",
    lastName: "Lee",
    description: "I am a snowboarding Junkie.",
    imageURL: "https://sotravel-uploads.s3.amazonaws.com/1678271403175_blob.jpeg",
    instagramUsername: "sotravel_sg",
    tiktokUsername: "sotravel.me",
    telegramUsername: "sotravel_sg",
    friends: mockFriends
)

let mockUser1 = User(
    id: UUID(),
    firstName: "Jane",
    lastName: "Doe",
    description: "I'm a beach lover and surfer!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
    instagramUsername: "janedoe",
    tiktokUsername: "janedoesurf",
    telegramUsername: "janedoetravel",
    friends: []
)

let mockUser2 = User(
    id: UUID(),
    firstName: "Micky",
    lastName: "Johnson",
    description: "I'm a history buff and love visiting ancient ruins!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "mikejohnson",
    tiktokUsername: "mikejohnsontravel",
    telegramUsername: "mikejohnsontravels",
    friends: []
)

let mockUser3 = User(
    id: UUID(),
    firstName: "Anna",
    lastName: "Smith",
    description: "I love hiking and exploring the great outdoors!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1509783236416-c9ad59bae472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "annasmith",
    tiktokUsername: "annasmithtravel",
    telegramUsername: "annasmithtravels",
    friends: []
)

let mockUser4 = User(
    id: UUID(),
    firstName: "John",
    lastName: "Lee",
    description: "I'm a foodie and love trying new restaurants!",
    instagramUsername: "johnlee",
    tiktokUsername: "johnleetravel",
    telegramUsername: "johnleetravels",
    friends: []
)

let mockUser5 = User(
    id: UUID(),
    firstName: "Sarah",
    lastName: "Kim",
    description: "I'm a nature lover and enjoy camping and hiking!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1531927557220-a9e23c1e4794?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjJ8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "sarahkim",
    tiktokUsername: "sarahkimtravel",
    telegramUsername: "sarahkimtravels",
    friends: []
)

let mockUser6 = User(
    id: UUID(),
    firstName: "Danielle",
    lastName: "Chen",
    description: "I'm an art enthusiast and enjoy visiting museums and galleries!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1542594452-f6a29cadbb22?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzN8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "davidchen",
    tiktokUsername: "davidchentravel",
    telegramUsername: "davidchentravels",
    friends: []
)

let mockUser7 = User(
    id: UUID(),
    firstName: "Lisa",
    lastName: "Wong",
    description: "I'm a fitness junkie and love trying new workout classes!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1527236438218-d82077ae1f85?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzJ8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "lisawong",
    tiktokUsername: "lisawongtravel",
    telegramUsername: "lisawongtravels",
    friends: []
)

let mockUser8 = User(
    id: UUID(),
    firstName: "Steph",
    lastName: "Zhang",
    description: "I'm a music lover and enjoy going to concerts and festivals!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8ZmFjZSUyMGltYWdlJTIwY2hpbmVzZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "stevenzhang",
    tiktokUsername: "stevenzhangtravel",
    telegramUsername: "stevenzhangtravels",
    friends: []
)

let mockUser9 = User(
    id: UUID(),
    firstName: "Grace",
    lastName: "Lee",
    description: "I'm a bookworm and love visiting libraries and bookstores!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1505033575518-a36ea2ef75ae?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "gracelee",
    tiktokUsername: "graceleetravel",
    telegramUsername: "graceleetravels",
    friends: []
)

let mockUser10 = User(
    id: UUID(),
    firstName: "Eliz",
    lastName: "Johnson",
    description: "I'm a sports fanatic and love attending games and matches!",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1521038199265-bc482db0f923?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGZhY2UlMjBpbWFnZSUyMGNoaW5lc2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "adamjohnson",
    tiktokUsername: "adamjohnsontravel",
    telegramUsername: "adamjohnsontravel",
    friends: []
)

let mockMe = User(
    id: UUID(uuidString: "003C8B4A-F831-43C8-9895-BF37DA40FA95") ?? UUID(),
    firstName: "Me",
    lastName: "Me",
    description: "I am a snowboarding Junkie.",
    imageURL: "https://sotravel-uploads.s3.amazonaws.com/1678271403175_blob.jpeg",
    instagramUsername: "sotravel_sg",
    tiktokUsername: "sotravel.me",
    telegramUsername: "sotravel_sg",
    friends: mockFriends
)

let mockNotMe = User(
    id: UUID(uuidString: "103C8B4A-F831-43C8-9895-BF37DA40FA95") ?? UUID(),
    firstName: "Not Me",
    lastName: "Not Me",
    description: "I am a snowboarding Junkie.",
    // swiftlint:disable:next line_length
    imageURL: "https://images.unsplash.com/photo-1505033575518-a36ea2ef75ae?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fGZhY2UlMjBpbWFnZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    instagramUsername: "gracelee",
    tiktokUsername: "graceleetravel",
    telegramUsername: "graceleetravels",
    friends: [mockMe]
)

var mockFriends = [
    mockUser1,
    mockUser2,
    mockUser3,
    mockUser4,
    mockUser5,
    mockUser6,
    mockUser7,
    mockUser8,
    mockUser9,
    mockUser10
]
