//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    @EnvironmentObject var eventService: EventService

    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601))
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        // Shows all events, when you scroll past the current date, calendar view should auto update
                        ForEach(eventService.eventViewModels, id: \.id) { eventViewModel in
                            EventView(eventViewModel: eventViewModel)
                        }
                        Spacer()
                    }
                }.padding(.horizontal)
            }.padding(.vertical)
        }
    }
}

struct InvitePageView_Previews: PreviewProvider {
    static var previews: some View {
        InvitePageView().environmentObject(EventService())
    }
}
