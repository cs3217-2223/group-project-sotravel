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
        VStack(alignment: .leading) {
            HStack {
                Text("I'm going to")
                    .font(.uiTitle3)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Spacer()
            }

            LazyVStack(spacing: 16) {
                ForEach(eventService.findAttendingEvents(for: user), id: \.id) { eventViewModel in
                    NavigationLink(destination: EventPageView(eventViewModel: eventViewModel)) {
                        EventView(eventViewModel: eventViewModel, isHideButton: true)
                    }
                }
            }

        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecentActivityView(user: mockUser3).environmentObject(EventsStore(events: mockEvents))
        }
    }
}
