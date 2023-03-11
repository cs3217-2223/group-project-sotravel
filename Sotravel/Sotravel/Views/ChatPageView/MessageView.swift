//
//  MessageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                Text("Fishing at Railay")
                    .font(.headline)
                    .clipped()
                Spacer()
                Text("Wed")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            // Show latest message by
            Text("Ashley: Just finished my morning coffee and feeling ready to take on the day! Trying to decide..")
                .foregroundColor(.gray)
                .font(Font.custom("Manrope-Regular", size: 14))
                .clipped()
                .padding(0)
            Divider().padding(.top, 8)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
