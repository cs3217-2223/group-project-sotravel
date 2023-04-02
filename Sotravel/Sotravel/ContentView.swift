import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService

    // MARK: Uncomment to reset login status
    init() {
        UserDefaults.standard.resetLogin()
    }

    var body: some View {
        if userService.isLoggedIn {
            TripsPageView()
        } else {
            LoginView()
        }
    }
}
