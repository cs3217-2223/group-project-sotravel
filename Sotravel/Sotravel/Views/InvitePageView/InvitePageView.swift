//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    var body: some View {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601))
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        // Shows all events, when you scroll past the current date, calendar view should auto update
                        EventView()
                        EventView()
                        EventView()
                        Spacer()
                    }
                }.padding(.horizontal)
            }.padding(.vertical)
        // Add FAB here to create event
    }
}

struct InvitePageView_Previews: PreviewProvider {
    static var previews: some View {
        InvitePageView()
    }
}
