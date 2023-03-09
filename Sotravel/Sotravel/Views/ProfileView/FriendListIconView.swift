//
//  FriendListIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct FriendListIconView: View {
    var body: some View {
        VStack {
            ProfileIconView()
                .frame(width: 200)
            Text("John")
                 .font(.title)
                 .opacity(0.5)
        }
        .frame(width: 100, height: 150)
    }
}

struct FriendListIconView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListIconView()
    }
}
