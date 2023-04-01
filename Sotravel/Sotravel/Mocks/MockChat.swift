import Foundation

let mockMessage1 = ChatMessage(
    messageText: "Hey guys, has anyone been to Railay Beach before?",
    timestamp: Date().addingTimeInterval(-3_600),
    sender: mockUser1.id
)
let mockMessage2 = ChatMessage(
    messageText: "Yes, I went there last year for rock climbing.",
    timestamp: Date().addingTimeInterval(-2_400),
    sender: mockUser2.id
)
let mockMessage3 = ChatMessage(
    messageText: "I haven't been there yet, but I heard it's a great place for fishing!",
    timestamp: Date().addingTimeInterval(-1_800),
    sender: mockUser.id
)
let mockMessage4 = ChatMessage(
    messageText: "I'm down for a fishing trip! When are we going?",
    timestamp: Date().addingTimeInterval(-1_200),
    sender: mockUser4.id
)
let mockMessage5 = ChatMessage(
    messageText: "How about next weekend?",
    timestamp: Date().addingTimeInterval(-600),
    sender: mockUser.id
)
let mockMessage6 = ChatMessage(
    messageText: "I'm busy next weekend, can we do it the weekend after that?",
    timestamp: Date(),
    sender: mockUser2.id
)
let mockMessage7 = ChatMessage(
    messageText: "Sure, that works for me. What kind of fish can we catch there?",
    timestamp: Date().addingTimeInterval(600),
    sender: mockUser3.id
)
let mockMessage8 = ChatMessage(
    messageText: "I heard there's plenty of barracuda, snapper, and grouper.",
    timestamp: Date().addingTimeInterval(1_200),
    sender: mockUser4.id
)
let mockMessage9 = ChatMessage(
    messageText: "Nice! We should bring some beers and have a barbecue on the beach afterwards.",
    timestamp: Date().addingTimeInterval(1_800),
    sender: mockUser1.id
)
let mockMessage10 = ChatMessage(
    messageText: "Sounds like a plan! Let's make it happen.",
    timestamp: Date().addingTimeInterval(2_400),
    sender: mockUser2.id
)

let mockChat = Chat(
    id: 1,
    messages: [
        mockMessage1,
        mockMessage2,
        mockMessage3,
        mockMessage4,
        mockMessage5,
        mockMessage6,
        mockMessage7,
        mockMessage8,
        mockMessage9,
        mockMessage10
    ]
    //    members: mockFriends
    //    event: mockEvent1
)

let mockChatNoEvent = Chat(
    id: 2,
    messages: [
        mockMessage6,
        mockMessage7
    ]
    //    title: "Test Title",
    //    members: mockFriends
)

// let mockChatNoMessage = Chat(members: mockFriends, event: mockEvent3)

let mockChats = [mockChat, mockChatNoEvent]
