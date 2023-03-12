//
//  CalenderView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Self.now
    @State var dragOffset = CGSize.zero
    @State var finalOffset: CGFloat = 0

    private static var now = Date()

    private let calendar: Calendar
    private let days: [Date]
    private let width = UIScreen.main.bounds.size.width

    let dateFormatter: DateFormatter

    init(calendar: Calendar) {
        self.calendar = calendar
        self.days = calendar.makeDays()

        dateFormatter = DateFormatter(dateFormat: "EEE, dd MMM", calendar: calendar)
        dateFormatter.locale = .autoupdatingCurrent
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(calendar.isDate(Date(), inSameDayAs: selectedDate) ? LocalizedStringKey("Today") : "\(selectedDate, formatter: dateFormatter)")
                .font(.uiTitle3)
            HStack {
                ForEach(self.days, id: \.self) { date in
                    DateCellView(date: date, calendar: calendar)
                        .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .uiPrimary :
                                            date < Date() ? .gray : .black)
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            .offset(x: dragOffset.width)
            .offset(x: finalOffset)
            .gesture(DragGesture()
                .onChanged({ value in
                    withAnimation(.spring()) {
                        self.dragOffset = value.translation
                    }
                })
                    .onEnded({ _ in
                        if dragOffset.width > 150 && finalOffset != (width + 10) {
                            withAnimation(.spring()) {
                                finalOffset += (width + 10)
                                dragOffset = .zero
                            }

                        } else if dragOffset.width < -150 && finalOffset != -(width + 10) {
                            withAnimation(.spring()) {
                                finalOffset -= (width + 10)
                                dragOffset = .zero
                            }

                        } else {
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                        }
                    })
            )
        }
        .background(Color.white)
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(calendar: Calendar(identifier: .iso8601))
    }
}
