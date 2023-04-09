import Foundation

extension Date {
    func isToday(using calendar: Calendar) -> Bool {
        let today = Date()

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: today)

        return dateComponents.year == todayDateComponents.year &&
            dateComponents.month == todayDateComponents.month &&
            dateComponents.day == todayDateComponents.day
    }

    func isTodayOrAfter(using calendar: Calendar) -> Bool {
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfOtherDate = calendar.startOfDay(for: self)
        return startOfOtherDate >= startOfToday
    }

    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }

    func formattedDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }

    func toFriendlyDayTimeString() -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.startOfDay(for: self)

        if date == today {
            formatter.dateFormat = "'Today at' h:mm a"
        } else {
            formatter.dateFormat = "EEE, MMM d 'at' h:mm a"
        }
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

    func toFriendlyString() -> String {
        "\(toFriendlyDateString()) at \(toFriendlyTimeString())"
    }

    // Show just time if it's today
    // Show date and time if it's not today
    func toFriendlyShortString() -> String {
        if isToday(using: Calendar(identifier: .iso8601)) {
            return toFriendlyTimeString()
        }

        return toFriendlyString()
    }
}
