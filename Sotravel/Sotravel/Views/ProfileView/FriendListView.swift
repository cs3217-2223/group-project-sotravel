//
//  FriendListView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct FriendListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friends")
                .font(.largeTitle)
                .padding(.leading)
            ScrollView(.horizontal) {
                HStack {
                    FriendListIconView()
                    FriendListIconView()
                    FriendListIconView()
                    FriendListIconView()
                }
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
