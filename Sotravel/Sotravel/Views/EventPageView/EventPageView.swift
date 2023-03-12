import SwiftUI

struct EventPageView: View {
    @EnvironmentObject var user: User
    @ObservedObject var event: Event
    @State private var selectedTab = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(event.title)
                    .font(.uiTitle2)
                Spacer()
            }.padding(.bottom, 10)
            HStack {
                Image(systemName: "calendar")
                    .imageScale(.medium)
                    .symbolRenderingMode(.monochrome)
                Text(event.datetime.formattedDateAndTime())
                    .font(.uiCallout)
            }
            HStack {
                Image(systemName: "location.fill")
                    .imageScale(.medium)
                    .symbolRenderingMode(.monochrome)
                Text(event.location)
                    .font(.uiCallout)
            }

            Text(event.description)
                .font(.uiBody)
                .foregroundColor(.black.opacity(0.5))
                .padding(.vertical, 8)

            // Attendees status
            VStack {
                HStack {
                    Text("Who's in? 👋")
                        .font(.uiTitle3)
                    Spacer()
                }

                AttendeesTabView(event: event)
            }.padding(.top, 6)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

}

struct EventPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventPageView(event: mockEvent1)
        }
    }
}
