import SwiftUI

struct DateCellView: View {

    @State var progress = Float.random(in: 0 ... 1)

    private let width = UIScreen.main.bounds.size.width

    let date: Date
    let calendar: Calendar
    let dateFormatter: DateFormatter
    let weekDayFormatter: DateFormatter

    init(date: Date, calendar: Calendar) {
        self.date = date
        self.calendar = calendar

        dateFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        weekDayFormatter.locale = .autoupdatingCurrent
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(date, formatter: weekDayFormatter)
                .scaledToFill()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .font(.uiBody)

            Text(date, formatter: dateFormatter)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .font(.uiBody)
        }
        .padding(10)
        .frame(width: width / 8, height: width / 4)
    }
}
