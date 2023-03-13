import SwiftUI

struct ChatView: View {
    @State var message = ""
    @State var messages: [Message] = [
        Message(text: "Hello", sender: .me, date: Date()),
        Message(text: "Hey, how are you?", sender: .someoneElse, date: Date()),
        Message(text: "I'm doing well, thanks. How about you?", sender: .me, date: Date()),
        Message(text: "I'm good too. What have you been up to?", sender: .someoneElse, date: Date()),
        Message(text: "Not much, just busy with work. How about you?", sender: .me, date: Date()),
        Message(text: "Same here. Work has been pretty hectic lately.", sender: .someoneElse, date: Date())
    ]

    var body: some View {
        VStack {
            List(messages) { message in
                ChatMessageView(message: message)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)

            HStack {
                TextField("Type a message...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if !message.isEmpty {
                        let newMessage = Message(text: message, sender: .me, date: Date())
                        messages.append(newMessage)
                        message = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
            }
            .padding()
        }
        .navigationBarTitle("Chat")
    }
}

struct ChatMessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.sender == .me {
                Spacer()
            }

            VStack(alignment: message.sender == .me ? .trailing : .leading, spacing: 5) {
                Text(message.text)
                    .padding(10)
                    .background(message.sender == .me ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(ChatBubbleShape(isFromCurrentUser: message.sender == .me))

                Text(message.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if message.sender != .me {
                Spacer()
            }
        }
        .padding(.horizontal, 5)
    }
}

enum MessageSender {
    case me
    case someoneElse
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let sender: MessageSender
    let date: Date
}

struct ChatBubbleShape: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 16

        var path = Path()
        if isFromCurrentUser {
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 0),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 0),
                        clockwise: true)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: true)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        return path
    }
}

struct ChatView_Previews: PreviewProvider {
    static let messages = [
        Message(text: "Hey there! How's it going?", sender: .someoneElse, date: Date()),
        Message(text: "Pretty good, thanks. How about you?", sender: .me, date: Date().addingTimeInterval(60)),
        Message(text: "Not too bad. Just trying to finish up this project.", sender: .someoneElse, date: Date().addingTimeInterval(120)),
        Message(text: "Oh yeah, that sounds tough. Good luck!", sender: .me, date: Date().addingTimeInterval(180))
    ]

    static var previews: some View {
        ChatView(messages: messages)
    }
}
