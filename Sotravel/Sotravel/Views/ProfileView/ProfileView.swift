//
//  ProfileView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var text: String = ""
    @State private var des: String = ""
    var body: some View {
        VStack {
            ProfileIconView()
                .frame(width: 300)
            Text("John")
                .fontWidth(Font.Width(50))
                .fontDesign(Font.Design.default)
            Divider()
            TextField("Description", text: $des)
                .padding(.all)
            FriendListView()
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
