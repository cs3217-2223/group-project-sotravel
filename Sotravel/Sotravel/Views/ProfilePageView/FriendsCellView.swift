//
//  FriendsCellView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/3/23.
//

import SwiftUI

struct FriendsCellView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("snowman")
                .resizable()
                .scaledToFit()
                .clipShape(Rectangle())
                .frame(width: 100)
            VStack {
                Text("John")
                    .bold()
                Text("Student")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .overlay(
                Rectangle()
                    .stroke(Color.gray, lineWidth: 0.5)
                    .frame(width: 100)
            )
        }
    }
}

struct FriendsCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsCellView()
    }
}
