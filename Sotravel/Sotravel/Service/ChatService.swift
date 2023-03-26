//
//  ChatService.swift
//  Sotravel
//
//  Created by Neo Wei Qing on 26/3/23.
//

import Foundation
// import Resolver
import Combine

class ChatService: ObservableObject {
    @Published var chatPageCellVMs: [ChatPageCellViewModel]
    @Published var chatHeaderVM: ChatHeaderViewModel
    @Published var chatMessageVMs: [ChatMessageViewModel]

    //    @Injected private var chatRepository: ChatRepository

    init() {
        self.chatPageCellVMs = []
        self.chatHeaderVM = ChatHeaderViewModel()
        self.chatMessageVMs = []
    }

    func fetchChatPageCells() {
        // TODO: call repository
        let chatPageCell1 = ChatPageCellViewModel(chatTitle: "Title 1", lastMessageText: "Text 1",
                                                  lastMessageSender: "Sender 1", lastMessageDate: Date.now,
                                                  id: UUID(uuidString: "1B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID())
        let chatPageCell2 = ChatPageCellViewModel(chatTitle: "Title 2", lastMessageText: "Text 2",
                                                  lastMessageSender: "Sender 2", lastMessageDate: Date.now,
                                                  id: UUID(uuidString: "2B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID())
        let chatPageCell3 = ChatPageCellViewModel(chatTitle: "Title 3", lastMessageText: "Text 3",
                                                  lastMessageSender: "Sender 3", lastMessageDate: Date.now,
                                                  id: UUID(uuidString: "3B2BA24E-A86E-4383-B1AA-D1D7D51BD24A") ?? UUID())
        chatPageCellVMs = [chatPageCell1, chatPageCell2, chatPageCell3]
    }

    func fetchChat(id: UUID) {
        // TODO: call repository
        let chatHeaderVM = ChatHeaderViewModel(chatTitle: "Title")
        let chatMessage1 = ChatMessageViewModel(messageText: "Message 1", senderName: "Me", isSentByMe: true)
        let chatMessage2 = ChatMessageViewModel(messageText: "Message 2", senderName: "Not Me", isSentByMe: false)
        let chatMessage3 = ChatMessageViewModel(messageText: "Message 3", senderName: "Me", isSentByMe: true)
        self.chatHeaderVM = chatHeaderVM
        chatMessageVMs = [chatMessage1, chatMessage2, chatMessage3]
    }
}
