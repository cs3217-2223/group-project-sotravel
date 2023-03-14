import SwiftUI

struct GroupChatHeaderView: View {
    var event: Event

    @Environment(\.dismiss) var dismiss
    var body: some View {

        HStack(spacing: 20) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.blue)
                .offset(y: -21)
                .onTapGesture {
                    withAnimation(.spring()) {
                        dismiss()
                    }
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.uiButton)
                    .lineLimit(1)
                Text(event.datetime.toFriendlyString())
                    .font(.uiSubheadline)
                    .lineLimit(1)
                NavigationLink(destination: EventPageView(event: event)) {
                    Text("View More")
                        .font(.uiFootnote)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }.padding(.leading, 20)
    }

}

struct GroupChatHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GroupChatHeaderView(event: mockEvent1)
        }
    }
}
