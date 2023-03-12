//
//  GroupChatView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 12/3/23.
//

import SwiftUI

struct GroupChatView: View {
    @State private var messageText = ""
    @FocusState private var isSending: Bool
    var body: some View {
        VStack {
            GroupChatHeaderView()
            Divider()
            ZStack {
                ScrollView {
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                    GroupChatCellView()
                }
                HStack {
                    TextField("Send Message...", text: $messageText)
                        .focused($isSending)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    Button(action: {}, label: {
                        Image(systemName: "face.smiling")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                    })
                    .padding(.trailing, 8)
                }
                .background(Color(.systemGray6)
                                .ignoresSafeArea())
                .cornerRadius(20)
                .padding()
                .position(CGPoint(x: 195,
                                  y: 565))
            }
        }
        .navigationBarBackButtonHidden()
    }
    func sendMessage() {
        // Implement sending logic here
        isSending = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSending = false
            messageText = ""
        }
    }
}

struct GroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatView()
    }
}
