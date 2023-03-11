//
//  ProfileIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color.primary)
                .edgesIgnoringSafeArea(.top)
                .frame(height: UIScreen.main.bounds.height / 5)
            Image("snowman")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
        }
    }
}

struct ProfileIconView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
    }
}
