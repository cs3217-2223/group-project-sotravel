//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    @EnvironmentObject var eventService: EventService
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601), selectedDate: $selectedDate)
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        // Shows events only on the same date as the selected date
                        ForEach(eventService.eventViewModels.filter { eventViewModel in
                            let calendar = Calendar.current
                            return calendar.isDate(eventViewModel.datetime, equalTo: selectedDate, toGranularity: .day)
                        }, id: \.id) { eventViewModel in
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
