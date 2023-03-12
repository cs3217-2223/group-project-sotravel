//
//  ChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ChatPageView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ChatPageCellView()
                ChatPageCellView()
                ChatPageCellView()
                ChatPageCellView()
                ChatPageCellView()
                ChatPageCellView()
            }
            .navigationTitle("Chat")
            .padding(.all)
        }
    }
}

struct ChatPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageView()
    }
}
