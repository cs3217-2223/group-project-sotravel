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
    @State private var currentPage = 1

    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601), selectedDate: $selectedDate)
                ScrollViewReader { _ in
                    TabView(selection: $currentPage) {
                        ForEach(-1...1, id: \.self) { index in
                            eventList(for: index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentPage) { newValue in
                        let diff = newValue - 1
                        selectedDate = Calendar.current.date(byAdding: .day, value: diff, to: selectedDate) ?? selectedDate
                    }
                }
            }.padding(.vertical)
        }
    }

    @ViewBuilder
    private func eventList(for index: Int) -> some View {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: index, to: selectedDate) ?? selectedDate

        VStack(spacing: 20) {
            ForEach(eventService.eventViewModels.filter { eventViewModel in
                calendar.isDate(eventViewModel.datetime, equalTo: date, toGranularity: .day)
            }, id: \.id) { eventViewModel in
                EventView(eventViewModel: eventViewModel)
            }
            Spacer()
        }
        .padding(.horizontal)
        .tag(index + 1)
    }
}

struct InvitePageView_Previews: PreviewProvider {
    static var previews: some View {
        InvitePageView().environmentObject(EventService())
    }
}
