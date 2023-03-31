//
//  CalenderView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct CalendarView: View {
    @Binding private var selectedDate: Date
    @State var dragOffset = CGSize.zero
    @State var finalOffset: CGFloat = 0

    private static var now = Date()

    private let calendar: Calendar
    private let days: [Date]
    private let width = UIScreen.main.bounds.size.width

    let dateFormatter: DateFormatter

    init(calendar: Calendar, selectedDate: Binding<Date>) {
        self.calendar = calendar
        self.days = calendar.makeDays()
        self._selectedDate = selectedDate

        dateFormatter = DateFormatter(dateFormat: "EEE, dd MMM", calendar: calendar)
        dateFormatter.locale = .autoupdatingCurrent
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(selectedDate.isToday(using: calendar)
                    ? LocalizedStringKey("Today")
                    : "\(selectedDate, formatter: dateFormatter)")
                .font(.uiTitle3)
            HStack {
                ForEach(self.days, id: \.self) { date in
                    DateCellView(date: date, calendar: calendar)
                        .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .uiPrimary :
                                            date.isTodayOrAfter(using: calendar) ? .primary : .gray)
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
    }
}

// struct CalendarView: View {
//    @EnvironmentObject private var eventService: EventService
//    @ObservedObject var viewModel: CalendarViewModel
//    @Binding private var selectedDate: Date
//    @State private var dragOffset: CGSize = .zero
//    @State private var finalOffset: CGFloat = 0
//
//    private let calendar: Calendar
//    private let days: [Date]
//    private let width = UIScreen.main.bounds.size.width
//    private let eventDates: [Date]
//
//    let dateFormatter: DateFormatter
//
//    init(calendar: Calendar, selectedDate: Binding<Date>, viewModel: CalendarViewModel) {
//        self.viewModel = viewModel
//        self.calendar = calendar
//        self._selectedDate = selectedDate
//
//        self.eventDates = viewModel.events.map { $0.datetime }
//        self.days = calendar.makeDays()
//
//        dateFormatter = DateFormatter(dateFormat: "EEE, dd MMM", calendar: calendar)
//        dateFormatter.locale = .autoupdatingCurrent
//    }
//
//    private func filteredDays() -> [Date] {
//        let futureEvents = viewModel.events.filter { $0.datetime >= Date() }
//        let futureEventDates = futureEvents.map { $0.datetime }
//
//        return days.filter { day in
//            futureEventDates.contains { eventDate in
//                calendar.isDate(day, inSameDayAs: eventDate)
//            }
//        }
//    }
//
//    private func maxDragOffset() -> CGFloat {
//        let cellWidth: CGFloat = 10
//        let maxOffset = CGFloat(filteredDays().count - 1) * cellWidth
//        return maxOffset
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Text(selectedDate.isToday(using: calendar)
//                    ? LocalizedStringKey("Today")
//                    : "\(selectedDate, formatter: dateFormatter)")
//                .font(.uiTitle3)
//            HStack {
//                ForEach(self.filteredDays(), id: \.self) { date in
//                    DateCellView(date: date, calendar: calendar)
//                        .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .uiPrimary :
//                                            date.isTodayOrAfter(using: calendar) ? .primary : .gray)
//                        .onTapGesture {
//                            selectedDate = date
//                        }
//                }
//            }
//            .offset(x: dragOffset.width)
//            .offset(x: finalOffset)
//            .gesture(DragGesture()
//                        .onChanged({ value in
//                            self.dragOffset.width = value.translation.width
//                        })
//                        .onEnded({ _ in
//                            let maxDragOffset = self.maxDragOffset()
//                            let snapWidth: CGFloat = 50
//
//                            if finalOffset + dragOffset.width < 0 {
//                                withAnimation(.spring()) {
//                                    finalOffset = 0
//                                }
//                                self.dragOffset = .zero
//                            } else if finalOffset + dragOffset.width > maxDragOffset {
//                                withAnimation(.spring()) {
//                                    finalOffset = maxDragOffset
//                                }
//                                self.dragOffset = .zero
//                            } else if dragOffset.width > snapWidth {
//                                withAnimation(.spring()) {
//                                    finalOffset += width + 10
//                                    dragOffset = .zero
//                                }
//                            } else if dragOffset.width < -snapWidth {
//                                withAnimation(.spring()) {
//                                    finalOffset -= width + 10
//                                    dragOffset = .zero
//                                }
//                            } else {
//                                withAnimation(.spring()) {
//                                    dragOffset = .zero
//                                }
//                            }
//                        })
//            )
//        }
//    }
// }

// struct CalenderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView(calendar: Calendar(identifier: .iso8601), selectedDate: .constant(Date()), viewModel: CalendarViewModel())
//    }
// }
