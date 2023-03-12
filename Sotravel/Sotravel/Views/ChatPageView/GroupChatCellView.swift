//
//  GroupChatCellView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct GroupChatCellView: View {
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "person")
            VStack(alignment: .leading) {
                Text("Judy")
                    .font(.uiTitle3)
                Text("Nice meeting you today")
                    .font(.uiBody)
            }
        }
    }
}

struct GroupChatCellView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatCellView()
    }
}
