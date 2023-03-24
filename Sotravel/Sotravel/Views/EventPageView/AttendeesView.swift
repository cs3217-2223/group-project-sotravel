import SwiftUI

struct AttendeesView: View {
    @State var selectedTab: Int = 0
    @ObservedObject var event: Event

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = 0
                }, label: {
                    Text("Going")
                        .font(.uiTab)
                })
                .foregroundColor(selectedTab == 0 ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(selectedTab == 0 ? Color.uiPrimary : Color(.systemFill))
                .cornerRadius(30, antialiased: true)

                Button(action: {
                    selectedTab = 1
                }, label: {
                    Text("Not Going")
                        .font(.uiTab)
                })
                .foregroundColor(selectedTab == 1 ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(selectedTab == 1 ? Color.uiPrimary : Color(.systemFill))
                .cornerRadius(30, antialiased: true)

                Button(action: {
                    selectedTab = 2
                }, label: {
                    Text("Pending")
                        .font(.uiTab)
                })
                .foregroundColor(selectedTab == 2 ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(selectedTab == 2 ? Color.uiPrimary : Color(.systemFill))
                .cornerRadius(30, antialiased: true)

                Spacer()
            }
            .padding(.bottom, 10)

            if selectedTab == 0 {
                UserHorizontalListView(users: event.attendingUsers)
            } else if selectedTab == 1 {
                UserHorizontalListView(users: event.rejectedUsers)
            } else if selectedTab == 2 {
                UserHorizontalListView(users: event.pendingUsers)
            }
        }
    }
}

struct AttendeesTabView_Previews: PreviewProvider {
    static var previews: some View {
        AttendeesView(event: mockEvent1)
    }
}
