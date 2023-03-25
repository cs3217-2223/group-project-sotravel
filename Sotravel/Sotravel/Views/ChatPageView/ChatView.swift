//
//  GroupChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatService: ChatService
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
                            // Show the timestamp above the message for the first message in a group
                            if shouldShowTimestampAboveMessage(for: chatMessageVM) {
                                Text(chatMessageVM.messageTimestamp.toFriendlyShortString()).font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }
                            ChatMessageView(chatMessageVM: chatMessageVM)
                                .font(.body)
                        }
                    }.onAppear {
                        if chatService.chatMessageVMs.isEmpty {
                            scrollViewProxy.scrollTo(chatService.chatMessageVMs.last?.id, anchor: .bottom)
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
        // TODO: send over to service
        print("sending")
        /*
         guard let user = userService.user else {
         // TODO: Throw a proper error here, mark this function as throws
         return
         }
         let success = chatViewModel.sendChatMessage(messageText: messageText, sender: user, toChat: chat)
         if !success {
         // TODO: handle message send failure
         return
         }
         messageText = ""
         isSending = true
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         isSending = false
         }
         */
    }

    func shouldShowTimestampAboveMessage(for chatMessageVM: ChatMessageViewModel) -> Bool {
        // TODO: shift this logic to service
        return true
        //        guard let index = chat.messages.firstIndex(where: { $0.id == message.id }) else {
        //            return false
        //        }
        //        if index == 0 {
        //            return true
        //        }
        //        let previousMessage = chat.messages[index - 1]
        //        return message.timestamp.timeIntervalSince(previousMessage.timestamp) > 60
    }
}

// struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: mockChatNoEvent).environmentObject(UserService())
//    }
// }
