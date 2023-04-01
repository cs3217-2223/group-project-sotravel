import SwiftUI

struct ContentView: View {
    @StateObject var userService = UserService()
    var body: some View {
        if userService.isLoggedIn {
            TripsPageView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserService())
            .environmentObject(EventsStore(events: mockEvents))
            .environmentObject(LocationSharingViewModel())
    }
}
