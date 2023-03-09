//
//  FooterIconView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct FooterIconView: View {
    var systemName: String
    var text: String
    var body: some View {
        VStack {
            Image(systemName: systemName)
                 .renderingMode(.template)
                 .font(.title)
                 .foregroundColor(.primary)
                 .opacity(0.5)
            Text(text)
                 .foregroundColor(.primary)
                 .font(.primary)
                 .opacity(0.5)
        }
    }
}

struct FooterIconView_Previews: PreviewProvider {
    static var previews: some View {
        FooterIconView(systemName: "person", text: "Profile")
    }
}
