import SwiftUI

struct ChatHeaderView: View {
    var chat: Chat

    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.blue)
                .offset(y: chat.event == nil ? 0 : -21)
                .onTapGesture {
                    withAnimation(.spring()) {
                        dismiss()
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(chat.title)
                    .font(.uiButton)
                    .lineLimit(1)
                if let event = chat.event {
                    Text(event.datetime.toFriendlyString())
                        .font(.uiSubheadline)
                        .lineLimit(1)
                    NavigationLink(destination: EventPageView(event: event)) {
                        Text("View More")
                            .font(.uiFootnote)
                            .foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }.padding(.leading, 20)
    }
}

struct ChatHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatHeaderView(chat: mockChatNoEvent)
        }
    }
}
