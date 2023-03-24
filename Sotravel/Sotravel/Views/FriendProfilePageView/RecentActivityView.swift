//
//  RecentActivityView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct RecentActivityView: View {
    @EnvironmentObject private var userServiice: UserService
    @EnvironmentObject var eventsStore: EventsStore
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
                ForEach(eventsStore.findAttendingEvents(for: user)) { event in
                    NavigationLink(destination: EventPageView(eventPageUserViewModel: $userServiice.eventPageViewModel, event: event)) {
                        EventView(event: event, isHideButton: true)
                    }
                }
            }

        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecentActivityView(user: mockUser3).environmentObject(EventsStore(events: mockEvents))
        }
    }
}
