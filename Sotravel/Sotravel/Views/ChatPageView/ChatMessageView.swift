import SwiftUI

struct ChatMessageView: View {
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var friendService: FriendService
    @ObservedObject var chatMessageVM: ChatMessageViewModel

    var body: some View {
        HStack {
            if chatMessageVM.isSentByMe ?? false {
                Spacer()
            } else {
                NavigationLink(destination: FriendProfilePageView(friend: friendService.getFriend(id: chatMessageVM.senderId))) {
                    ProfileImageView(imageSrc: friendService.getFriend(id: chatMessageVM.senderId)?.imageURL,
                                     name: friendService.getFriend(id: chatMessageVM.senderId)?.name ?? "", width: 30, height: 30)
                }
            }

            Text(chatMessageVM.messageText ?? "")
                .padding(10)
                .background((chatMessageVM.isSentByMe ?? false) ? Color.blue : Color(.systemGray5))
                .foregroundColor((chatMessageVM.isSentByMe ?? false) ? .white : .primary)
                .cornerRadius(20)
                .padding(.horizontal, 5)

            if !(chatMessageVM.isSentByMe ?? false) {
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .animation(.easeInOut(duration: 0.5), value: 1.0)
    }
}

// struct ChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessageView(chatMessage: mockMessage1, isSentByMe: false).environmentObject(UserService())
//    }
// }
