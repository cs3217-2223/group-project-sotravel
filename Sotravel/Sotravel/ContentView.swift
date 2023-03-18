import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userDataManager: UserDataManager
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserDataManager())
            .environmentObject(EventsStore(events: mockEvents))
    }
}
