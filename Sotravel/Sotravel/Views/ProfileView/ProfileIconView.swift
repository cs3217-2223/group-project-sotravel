//
//  ProfileIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileIconView: View {
    var body: some View {
        Image("snowman")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
    }
}

struct ProfileIconView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileIconView()
    }
}
