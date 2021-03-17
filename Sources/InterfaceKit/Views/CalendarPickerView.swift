//
//  CalendarPickerView.swift
//  
//
//  Created by Maddie Schipper on 3/16/21.
//

import SwiftUI

public struct CalendarPickerView<DayView: View> : View {
    @Environment(\.calendar) private var calendar
    
    private let date: Binding<Date>
    private let provider: (CalendarDay) -> DayView
    private let dateRange: DateInterval
    private let dateFormatter: DateFormatter?
    
    @State private var presentedDate: Date
    
    public init(date: Binding<Date>, dateRange: DateInterval = .init(start: .distantPast, end: .distantFuture), @ViewBuilder provider: @escaping (CalendarDay) -> DayView) {
        self.date = date
        self.provider = provider
        self._presentedDate = State(wrappedValue: date.wrappedValue)
        self.dateRange = dateRange
        self.dateFormatter = nil
    }
    
    public var body: some View {
        _MonthView($presentedDate, dateFormatter, calendar, dateRange, date, provider)
            .frame(minWidth: 300.0, minHeight: 270.0, alignment: .top)
    }
}

public struct CalendarDay {
    public let date: Date
    public let isDisplayedMonth: Bool
    public let isToday: Bool
    public let dayOfMonth: Int
}

public struct SimpleCalendarDayView : View {
    private let day: CalendarDay
    
    public init(day: CalendarDay) {
        self.day = day
    }
    
    public var body: some View {
        Text(String(day.dayOfMonth))
            .modifier(CenterViewModifier())
            .modifier(CircularBorderViewModifier(lineWidth: day.isToday ? 2.0 : 0.0, lineColor: Color.separator))
            .hidden(notHidden: day.isDisplayedMonth)
    }
}

fileprivate struct _MonthView<DayView : View> : View {
    private let date: Binding<Date>
    private let presented: Binding<Date>
    private let provider: (CalendarDay) -> DayView
    private let month: _Month
    private let columns: Array<GridItem>
    private let dayNames: Array<String>
    private let dateRange: DateInterval
    private let previous: Date
    private let next: Date
    
    init(_ presentedDate: Binding<Date>, _ formatter: DateFormatter?, _ calendar: Calendar, _ range: DateInterval, _ date: Binding<Date>, _ provider: @escaping (CalendarDay) -> DayView) {
        let df = formatter ?? {
            let f = DateFormatter()
            f.locale = calendar.locale
            f.dateFormat = "MMMM YYYY"
            return f
        }()
        
        self.date = date
        self.dateRange = range
        self.provider = provider
        self.presented = presentedDate
        self.month = _Month(presentedDate.wrappedValue, df, calendar)
        self.columns = Array(repeating: .init(spacing: 0.0), count: 7)
        self.dayNames = calendar._sortedShortWeekdaySymbols
        self.previous = presentedDate.wrappedValue.previousMonth(calendar)
        self.next = presentedDate.wrappedValue.nextMonth(calendar)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0.0) {
            Section(header: header) {
                ForEach(dayNames, id: \.self) {
                    Text($0)
                }.font(.subheadline).foregroundColor(.secondary)
                ForEach(month.days) { day in
                    self.provider(day.calendarDay)
                        .aspectRatio(1.0, contentMode: .fit)
                        .onTapGesture {
                            self.date.wrappedValue = day.date
                        }
                }
            }
        }
    }
    
    var header: some View {
        HStack {
            Text(month.localizedName)
                .bold()
                .onTapGesture {
                    withAnimation {
                        self.presented.wrappedValue = self.date.wrappedValue
                    }
                }
            Spacer()
            HStack {
                Button {
                    withAnimation { self.presented.wrappedValue = previous }
                } label: {
                    Image(systemName: "chevron.left")
                }
                .keyboardShortcut(.leftArrow)
                .disabled(previous < dateRange.start)
                Button {
                    withAnimation { self.presented.wrappedValue = next }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .keyboardShortcut(.rightArrow)
                .disabled(next > dateRange.end)
            }.buttonStyle(PlainButtonStyle())
        }
        .padding(.bottom, 8.0)
    }
}

fileprivate extension Date {
    func nextMonth(_ calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.month, .day, .year], from: self)
        if components.month == 12 {
            components.year! += 1
            components.month = 1
        } else {
            components.month! += 1
        }
        
        return calendar.date(from: components)!
    }
    
    func previousMonth(_ calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.month, .day, .year], from: self)
        if components.month == 1 {
            components.year! -= 1
            components.month = 12
        } else {
            components.month! -= 1
        }
        
        return calendar.date(from: components)!
    }
}

fileprivate struct _Month : Identifiable {
    let id = UUID()
    
    let date: Date
    let days: Array<_Day>
    let localizedName: String
    
    init(_ month: Date, _ formatter: DateFormatter, _ calendar: Calendar) {
        self.date = month
        self.localizedName = formatter.string(from: month)
        self.days = _Month.days(month, calendar).map {
            _Day(
                date: $0,
                isMonth: calendar.isDate($0, equalTo: month, toGranularity: .month),
                isToday: calendar.isDate($0, equalTo: Date(), toGranularity: .day),
                day: calendar.component(.day, from: $0)
            )
        }
    }
    
    private static func days(_ month: Date, _ calendar: Calendar) -> Array<Date> {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        
        let interval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        
        return calendar._generate(datesWithin: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
}

fileprivate struct _Day : Identifiable {
    let id = UUID()
    let date: Date
    let isMonth: Bool
    let isToday: Bool
    let day: Int
    
    var calendarDay: CalendarDay {
        CalendarDay(date: date, isDisplayedMonth: isMonth, isToday: isToday, dayOfMonth: day)
    }
}

extension Calendar {
    fileprivate func _generate(datesWithin interval: DateInterval, matching components: DateComponents) -> Array<Date> {
        var dates = Array<Date>()
        
        dates.append(interval.start)
        
        self.enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { unsafeDate, _, stop in
            guard let date = unsafeDate else {
                return
            }
            
            if date >= interval.end {
                stop = true
            } else {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    fileprivate var _sortedShortWeekdaySymbols: Array<String> {
        let weekDays = self.shortWeekdaySymbols
        let firstIndex = self.firstWeekday - 1
        
        return Array(
            weekDays[firstIndex ..< weekDays.count] +
                weekDays[0 ..< firstIndex]
        )
    }
}

struct CalendarPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarPickerView(date: .constant(Date())) {
                SimpleCalendarDayView(day: $0)
            }.preferredColorScheme(.dark)
            CalendarPickerView(date: .constant(Date())) {
                SimpleCalendarDayView(day: $0)
            }.preferredColorScheme(.light)
        }
    }
}
