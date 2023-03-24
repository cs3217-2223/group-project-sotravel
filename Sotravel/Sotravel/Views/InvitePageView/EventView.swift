import SwiftUI

struct EventView: View {
    @ObservedObject var event: Event
    var isHideButton = false

    var body: some View {
        VStack {
            HStack(spacing: 47) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.datetime.toFriendlyTimeString())
                        .font(.uiHeadline)
                        .foregroundColor(Color.primary)
                    Text(event.datetime.toFriendlyDateString())
                        .font(.uiCallout)
                        .foregroundColor(Color.gray)
                }.offset(x: 4, y: -7)
                VStack(spacing: 7) {
                    Text(event.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .font(.uiHeadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(event.location)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .font(.uiCallout)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .lineLimit(1)
                    NavigationLink(destination: EventPageView(event: event)) {
                        HStack(spacing: 0) {
                            Text("\(event.attendingUsers.count) Going")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .clipped()
                                .font(.uiFootnote)
                                .foregroundColor(.blue.opacity(0.8))
                            ZStack {
                                let renderedUsers = event.attendingUsers.prefix(3)
                                ForEach(Array(renderedUsers.prefix(3).reversed().enumerated()), id: \.1.id) { index, user in
                                    ProfileImageView(
                                        imageSrc: user.imageURL,
                                        name: user.name,
                                        width: 30,
                                        height: 30
                                    )
                                    .offset(x: CGFloat(22 * (renderedUsers.count - index - 1)))
                                }
                            }.offset(x: -50)
                        }
                        .padding(.top, 1)
                    }
                }
            }
            if !isHideButton {
                NavigationLink(destination: EventPageView(event: event)) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Join")
                    }
                    .font(.uiButton)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .foregroundColor(Color.uiPrimary)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.clear.opacity(0.25), lineWidth: 0)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.uiPrimary.opacity(0.1)))
                    }
                }
            }
        }
        .padding(16)
        .clipped()
        .mask { RoundedRectangle(cornerRadius: 20, style: .continuous) }
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.3), lineWidth: 1))
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: mockEvent1)
    }
}
