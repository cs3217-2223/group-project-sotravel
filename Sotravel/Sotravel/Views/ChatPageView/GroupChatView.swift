//
//  GroupChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct GroupChatView: View {
    var event: Event
    @EnvironmentObject var user: User
    @State var chat: Chat
    @State private var messageText = ""
    @State private var isSending = false
    @ObservedObject private var keyboard = KeyboardResponder()

    var isSendDisabled: Bool {
        messageText.isEmpty || isSending
    }

    init(event: Event, chat: Chat, messageText: String = "") {
        self.event = event
        self.chat = chat
        self.messageText = messageText
    }

    var body: some View {
        VStack {
            GroupChatHeaderView(event: event)
            Divider()

            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    LazyVStack {
                        ForEach(chat.messages, id: \.id) {message in
                            // Show the timestamp above the message for the first message in a group
                            if shouldShowTimestampAboveMessage(for: message) {
                                Text(message.timestamp.toFriendlyShortString()).font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }
                            ChatMessageView(chatMessage: message, isSentByMe: message.sender == user).font(.body)
                                .id(message.id)
                        }
                    }.onAppear {
                        if chat.messages.isEmpty {
                            scrollViewProxy.scrollTo(chat.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("Send Message...", text: $messageText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .font(.body)
                Button(action: {
                    sendMessage()
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .rotationEffect(.degrees(45))
                        .offset(x: -2)
                })
                .background(isSendDisabled ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .disabled(isSendDisabled)
            }
            .background(Color(.systemGray6)
                            .ignoresSafeArea())
            .cornerRadius(20)
            .padding()
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading : .bottom)
        }.navigationBarBackButtonHidden(true)
    }

    func sendMessage() {
        messageText = ""
        isSending = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isSending = false
        }
    }

    func shouldShowTimestampAboveMessage(for message: ChatMessage) -> Bool {
        guard let index = chat.messages.firstIndex(where: { $0.id == message.id }) else {
            return false
        }
        if index == 0 {
            return true
        }
        let previousMessage = chat.messages[index - 1]
        return message.timestamp.timeIntervalSince(previousMessage.timestamp) > 60
    }
}

struct GroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatView(event: mockEvent1, chat: mockChat).environmentObject(mockUser)
    }
}
