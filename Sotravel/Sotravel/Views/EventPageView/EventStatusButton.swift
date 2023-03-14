import SwiftUI

enum EventStatus {
    case pending
    case going
    case notGoing
}

struct EventStatusButton: View {
    @Binding var eventStatus: EventStatus
    @State private var isMenuVisible = false

    var body: some View {
        Menu {
            Button(action: { eventStatus = .going }, label: {
                Label("Going", systemImage: "checkmark.circle")
            })
            Button(action: { eventStatus = .notGoing }, label: {
                Label("Not Going", systemImage: "xmark.circle")
            })
            Button(action: { eventStatus = .pending }, label: {
                Label("Pending", systemImage: "clock")
            })
        } label: {
            HStack {
                Text(statusString)
                    .foregroundColor(statusColor)
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .foregroundColor(statusColor)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(statusColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(statusColor, lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }

    var statusString: String {
        switch eventStatus {
        case .pending:
            return "Are you going?"
        case .going:
            return "Going"
        case .notGoing:
            return "Not Going"
        }
    }

    var statusColor: Color {
        switch eventStatus {
        case .pending:
            return Color.uiPrimary
        case .going:
            return Color.uiPrimary
        case .notGoing:
            return Color.red
        }
    }
}
