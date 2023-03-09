//
//  EventView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(.black, lineWidth: 5)
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    Text("14:00")
                        .font(.title)
                        .padding(.leading)
                    ScrollView(.vertical) {
                        Text("Hello, World! Hello, World! Hello, World! Hello, World! Hello, World! Hello, World!, Hello, World! Hello, World! Hello, World! Hello, World! ")
                            .font(.primary)
                            .padding(.trailing)
                    }
                }
                Spacer()
                ColoredDividerView()
                Button(action: {
                    // Join action
                }) {
                    Text("Join")
                        .font(.primary700)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(5)
                }
            }
            .clipped()
        }
        .frame(maxWidth: UIScreen.main.bounds.width,
               maxHeight: UIScreen.main.bounds.height/4,
               alignment: .center)
        .clipped()
        .padding([.all])
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
