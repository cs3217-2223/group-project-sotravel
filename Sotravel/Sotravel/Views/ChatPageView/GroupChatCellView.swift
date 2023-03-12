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
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text("Judy")
                    .font(.uiTitle3)
                Text("Nice meeting you today, hope to see you again !")
                    .font(.uiBody)
            }
        }
        .padding(.horizontal)
    }
}

struct GroupChatCellView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatCellView()
    }
}
