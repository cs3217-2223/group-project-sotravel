import SwiftUI

struct ChatMessageView: View {
    let chatMessage: ChatMessage
    let isSentByMe: Bool

    var body: some View {
        HStack {
            if isSentByMe {
                Spacer()
            } else {
                NavigationLink(destination: FriendProfilePageView(friend: chatMessage.sender)) {
                    ProfileImageView(imageSrc: chatMessage.sender.imageURL, name: chatMessage.sender.name, width: 30, height: 30)
                }
            }

            Text(chatMessage.messageText)
                .padding(10)
                .background(isSentByMe ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSentByMe ? .white : .primary)
                .cornerRadius(20)
                .padding(.horizontal, 5)

            if !isSentByMe {
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .animation(.easeInOut(duration: 0.5), value: 1.0)
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(chatMessage: mockMessage1, isSentByMe: false).environmentObject(UserDataManager())
    }
}
