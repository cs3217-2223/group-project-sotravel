//
//  GroupChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var eventService: EventService
    @State private var messageText = ""
    @State private var isSending = false
    @ObservedObject private var keyboard = KeyboardResponder()

    var isSendDisabled: Bool {
        messageText.isEmpty || isSending
    }

    var body: some View {
        VStack {
            ChatHeaderView(chatHeaderVM: chatService.chatHeaderVM)
            Divider()

            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    LazyVStack {
                        ForEach(chatService.chatMessageVMs) { chatMessageVM in
                            if chatService.shouldShowTimestampAboveMessage(for: chatMessageVM) {
                                Text(chatMessageVM.messageTimestamp.toFriendlyShortString()).font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }
                            ChatMessageView(chatMessageVM: chatMessageVM)
                                .font(.body)
                        }
                        Spacer().id("-1")
                    }.onChange(of: chatService.chatMessageVMs.count) { _ in
                        scrollViewProxy.scrollTo("-1")
                    }
                }
            }.onTapGesture {
                dismissKeyboard()
            }

            HStack {
                // TODO: check this text field
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
            .padding(.horizontal)
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading : .bottom)
        }
    }

    // Helper function to dismiss the keyboard
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func sendMessage() {
        isSending = true
        let success = chatService.sendChatMessage(messageText: messageText)
        if !success {
            // TODO: show some alert
            return
        }
        messageText = ""
        isSending = false
    }
}

// struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//            .environmentObject(UserService())
//            .environmentObject(ChatService())
//            .environmentObject(EventService())
//    }
// }
