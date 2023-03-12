import Foundation

extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }

    func formattedDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }

    func toFriendlyTimeString() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }

    func toFriendlyDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"

        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else {
            return dateFormatter.string(from: self)
        }
    }
}
