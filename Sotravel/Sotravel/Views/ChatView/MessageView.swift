//
//  MessageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.title)
                    .clipped()
                Text("Just finished my morning coffee and feeling ready to take on the day! Trying to decide what to have for dinner tonight... any suggestions?")
                    .font(.primary)
                    .clipped()
            }
            Spacer()
            Text("Wed")
                .font(.primary500)
                .opacity(0.5)
        }
        .frame(height: UIScreen.main.bounds.height / 10)
        .padding(.all)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
