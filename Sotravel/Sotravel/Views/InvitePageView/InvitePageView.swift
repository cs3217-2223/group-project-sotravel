//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    @EnvironmentObject var eventsStore: EventsStore

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                CalendarView(calendar: Calendar(identifier: .iso8601))
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        // Shows all events, when you scroll past the current date, calendar view should auto update
                        ForEach(eventsStore.events) { event in
                            EventView(event: event)
                        }
                        Spacer()
                    }
                }.padding(.horizontal)
            }.padding(.vertical)

            // Floating action button
            // TODO: Not sure why when I add this it screws up the layout
            //            Button(action: {
            //                // Add your button action here
            //            }) {
            //                Image(systemName: "plus")
            //                    .font(.system(size: 24))
            //                    .foregroundColor(.white)
            //                    .padding()
            //                    .background(Color.primary)
            //                    .clipShape(Circle())
            //                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 1, y: 2)
            //            }
            //            .padding(16)
        }
    }
}

struct InvitePageView_Previews: PreviewProvider {
    static var previews: some View {
        InvitePageView().environmentObject(EventsStore(events: mockEvents))
    }
}
