//
//  RecentActivityView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct RecentActivityView: View {
    @EnvironmentObject private var userServiice: UserService
    @EnvironmentObject private var eventService: EventService
    var user: User

    var body: some View {
        let attendingEvents = eventService.findAttendingEventsVM(for: user)
        VStack(alignment: .leading) {
            HStack {
                Text("Invites I'm going to")
                    .font(.uiTitle3)
                Image(systemName: "megaphone.fill")
                    .foregroundColor(.green)
                Spacer()
            }

            if attendingEvents.isEmpty {
                Text("I'm not going to any invites yet.")
                    .font(.uiBody)
                    .foregroundColor(.gray)
                    .padding(.top)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(attendingEvents, id: \.id) { eventViewModel in
                        NavigationLink(destination: EventPageView(eventViewModel: eventViewModel)) {
                            EventView(eventViewModel: eventViewModel, isHideButton: true)
                        }
                    }
                }
            }
        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecentActivityView(user: mockUser3).environmentObject(EventsStore(events: mockEvents)).environmentObject(UserService())
        }
    }
}
