//
//  FriendsView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/3/23.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friends")
                .padding(.leading)
                .bold()
                .font(.title)
            ScrollView(.horizontal) {
                HStack {
                    FriendsCellView()
                    FriendsCellView()
                    FriendsCellView()
                    FriendsCellView()
                    FriendsCellView()
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
