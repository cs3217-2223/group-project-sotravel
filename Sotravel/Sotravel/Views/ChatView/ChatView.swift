//
//  ChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                MessageView()
                MessageView()
                MessageView()
                MessageView()
                MessageView()
                MessageView()
            }
            .navigationTitle("Chat")
            .padding(.all)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
