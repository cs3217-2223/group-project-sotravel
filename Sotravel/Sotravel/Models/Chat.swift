class Chat {
    var messages = [ChatMessage]()

    init(messages: [ChatMessage] = [ChatMessage]()) {
        self.messages = messages
    }

    func addChatMessage(_ message: ChatMessage) {
        messages.append(message)
    }
}
