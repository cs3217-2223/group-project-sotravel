//
//  InvitePageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct InvitePageView: View {
    var body: some View {
        VStack {
            CalendarView()
            ColoredDividerView()
            ScrollView(.vertical) {
                EventView()
                EventView()
                EventView()
            }
            ColoredDividerView()
            Button(action: {
                                // Join action
            }) {
                Text("Create an Invite")
            }
            .buttonStyle(.borderedProminent)
            .padding(.all)
        }
    }
}

struct InvitePageView_Previews: PreviewProvider {
    static var previews: some View {
        InvitePageView()
    }
}
