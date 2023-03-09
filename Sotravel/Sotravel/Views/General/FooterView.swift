//
//  FooterView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 45) {
            FooterIconView(systemName: "map.fill", text: "Map")
            FooterIconView(systemName: "person.3.sequence.fill", text: "Invites")
            FooterIconView(systemName: "message.fill", text: "Chat")
            FooterIconView(systemName: "person.fill", text: "Profile")
        }
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
    }
}
