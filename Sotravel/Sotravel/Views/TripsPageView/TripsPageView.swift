import SwiftUI

struct TripsPageView: View {
    let trips: [Trip] = mockTrips
    @EnvironmentObject var chatService: ChatService
    @EnvironmentObject var userService: UserService

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("My Trips")
                        .font(.uiTitle1)
                    Spacer()
                }
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(trips) { trip in
                        NavigationLink(destination: TripPageView()) {
                            TripCardView(trip: trip)
                        }.foregroundColor(.primary)
                        .simultaneousGesture(TapGesture().onEnded {
                            self.chatService.setUserId(user: self.userService.user)
                            self.chatService.fetchChatPageCells()
                        })
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TripsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripsPageView()
                .environmentObject(UserService())
                .environmentObject(ChatService())
                .environmentObject(EventsStore(events: mockEvents))
        }
    }
}
