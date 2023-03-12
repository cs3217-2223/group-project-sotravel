//
//  GroupChatHeaderView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct GroupChatHeaderView: View {
    var body: some View {
        HStack(spacing: 35) {
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width: 20, height: 30)
                .opacity(0.5)
                .offset(x: -10, y: -15)
            VStack(alignment: .leading, spacing: 10) {
                Text("Climb at Ao Nang Tower")
                    .font(.uiTitle2)
                    .bold()
                Text("Tomorrow, 5.30pm")
                    .font(.uiBody)
                Button(action: {}, label: {
                    Text("View More")
                        .font(.uiButton)
                })
            }

        }
    }
}

struct GroupChatHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatHeaderView()
    }
}
