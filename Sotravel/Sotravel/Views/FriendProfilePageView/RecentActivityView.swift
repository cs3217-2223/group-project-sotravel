//
//  RecentActivityView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct RecentActivityView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Going")
                    .font(.uiTitle1)
                    .padding(.leading)
                Spacer()
            }
            ScrollView {
                EventView(event: mockEvent1)
                EventView(event: mockEvent2)
            }
        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        RecentActivityView()
    }
}
