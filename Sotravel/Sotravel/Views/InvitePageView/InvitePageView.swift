//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var eventService: EventService
    @EnvironmentObject var tripService: TripService
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601), selectedDate: $selectedDate)
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        let filteredEvents = eventService.eventViewModels.filter { eventViewModel in
                            let calendar = Calendar.current
                            return calendar.isDate(eventViewModel.datetime, equalTo: selectedDate, toGranularity: .day)
                        }
                        if filteredEvents.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                Text("Would you like to create an invite?")
                                    .font(.uiHeadline)
                                    .foregroundColor(Color(.systemGray))

                                Button(action: {
                                    self.navigateToCreateInvitePage()
                                }) {
                                    Text("Create")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                                Spacer()
                            }
                            .padding(.horizontal)

                        } else {
                            ForEach(filteredEvents, id: \.id) { eventViewModel in
                                EventView(eventViewModel: eventViewModel)
                            }
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal)
                .refreshable {
                    await refreshEvents()
                }
            }.padding(.vertical)
        }
    }

    @MainActor
    private func refreshEvents() async {
        guard let userId = userService.getUserId(), let tripId = tripService.getCurrTripId() else {
            return
        }
        eventService.reloadUserEvents(forTrip: tripId, userId: userId)
    }

    private func navigateToCreateInvitePage() {
        tripService.selectedTapInCurrTrip = 2
    }
}

// struct InvitePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        InvitePageView().environmentObject(EventService())
//    }
// }
