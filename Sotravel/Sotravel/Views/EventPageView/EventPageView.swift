import SwiftUI

struct EventPageView: View {
    @EnvironmentObject var user: User
    @ObservedObject var event: Event

    var body: some View {
        VStack {
            // Event title
            Text(event.description)
                .font(.uiTitle1)
                .padding(.top, 50)

            // Event Date and time
            Text(event.datetime.formattedDateAndTime())
                .font(.uiSubheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)

            // Event location
            Text(event.location)
                .font(.uiSubheadline)
                .padding(.top, 5)

            // Attendees status
            HStack {
                Text("Attendees")
                    .font(.uiHeadline)
                    .padding(.top, 20)
                Spacer()
            }

            HStack {
                // Going
                VStack {
                    Text("Going")
                        .font(.uiBody)
                    ForEach(event.attendingUsers, id: \.self) { user in
                        Text(user.name)
                            .font(.uiCaption1)
                    }
                }

                Spacer()

                // Not going
                VStack {
                    Text("Not Going")
                        .font(.uiBody)
                    ForEach(event.rejectedUsers, id: \.self) { user in
                        Text(user.name)
                            .font(.uiCaption1)
                    }
                }

                Spacer()

                // Pending
                VStack {
                    Text("Pending")
                        .font(.uiBody)
                    ForEach(event.pendingUsers, id: \.self) { user in
                        Text(user.name)
                            .font(.uiCaption1)
                    }
                }
            }
            .padding(.top, 10)

            // Choose status
            HStack {
                Button(action: { event.attendingUsers.append(user) }) {
                    Text("Going")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 100)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }

                Button(action: { event.rejectedUsers.append(user) }) {
                    Text("Not Going")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 100)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }

                Button(action: {}) {
                    Text("Pending")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 100)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
            }
            .padding(.top, 30)

            // Group chat
            VStack {
                Text("Group Chat")
                    .font(.uiTitle2)
                    .padding(.top, 30)

                ScrollView {
                    VStack {
                        ForEach(0..<10) { index in
                            Text("Message \(index + 1)")
                                .padding(.vertical, 10)
                        }
                    }
                }

                HStack {
                    TextField("Type your message...", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)

                    Button(action: {}) {
                        Text("Send")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                    }
                }
                .padding(.vertical, 20)
            }
            .padding(.top, 30)

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct EventPageView_Previews: PreviewProvider {
    static var previews: some View {
        return EventPageView(event: mockEvent1)
    }
}
