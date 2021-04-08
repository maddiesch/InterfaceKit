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
    private let spacing: CGFloat?
    
    @State private var presentedDate: Date
    
    public init(date: Binding<Date>, dateRange: DateInterval = .init(start: .distantPast, end: .distantFuture), spacing: CGFloat? = nil, @ViewBuilder provider: @escaping (CalendarDay) -> DayView) {
        self.date = date
        self.provider = provider
        self.dateRange = dateRange
        self.dateFormatter = nil
        self.spacing = spacing
        
        if date.wrappedValue < dateRange.start {
            self._presentedDate = State(wrappedValue: dateRange.start)
        } else if date.wrappedValue > dateRange.end {
            self._presentedDate = State(wrappedValue: dateRange.end)
        } else {
            self._presentedDate = State(wrappedValue: date.wrappedValue)
        }
    }
    
    public var body: some View {
        _CalendarPickerViewImpl($presentedDate, dateFormatter, calendar, dateRange, date, spacing, provider)
            .aspectRatio(0.82, contentMode: .fit)
            .frame(minWidth: 220.0, minHeight: 220.0 / 0.82)
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
            .hide(unless: day.isDisplayedMonth)
    }
}

fileprivate struct _CalendarPickerViewImpl<DayView : View> : View {
    private let date: Binding<Date>
    private let presented: Binding<Date>
    private let provider: (CalendarDay) -> DayView
    private let month: _Month
    private let columns: Array<GridItem>
    private let dayNames: Array<String>
    private let dateRange: DateInterval
    private let previous: Date
    private let next: Date
    private let spacing: CGFloat
    private let calendar: Calendar
    private let ranges: [Range<Int>] = [
        (0..<7),
        (7..<14),
        (14..<21),
        (21..<28),
        (28..<35),
        (35..<42)
    ]
    
    init(_ presentedDate: Binding<Date>, _ formatter: DateFormatter?, _ calendar: Calendar, _ range: DateInterval, _ date: Binding<Date>, _ spacing: CGFloat?, _ provider: @escaping (CalendarDay) -> DayView) {
        let df = formatter ?? {
            let f = DateFormatter()
            f.locale = calendar.locale
            f.dateFormat = "MMMM YYYY"
            return f
        }()
        
        self.date = date
        self.calendar = calendar
        self.dateRange = range
        self.provider = provider
        self.presented = presentedDate
        self.month = _Month(presentedDate.wrappedValue, df, calendar)
        self.columns = Array(repeating: .init(spacing: spacing), count: 7)
        self.dayNames = calendar._sortedShortWeekdaySymbols
        self.previous = presentedDate.wrappedValue.previousMonth(calendar)
        self.next = presentedDate.wrappedValue.nextMonth(calendar)
        self.spacing = spacing ?? 0.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0.0) {
                self.header
                Divider().padding(.bottom)
                HStack(spacing: spacing) {
                    ForEach(dayNames, id: \.self) { dayName in
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            Text(dayName)
                            Spacer(minLength: 0.0)
                        }
                        .foregroundColor(.secondary)
                        .frame(width: (geometry.size.width - (spacing * 6.0)) / 7.0)
                    }
                }.frame(width: geometry.size.width)
                VStack(spacing: spacing) {
                    ForEach(ranges, id: \.lowerBound) { range in
                        HStack(spacing: spacing) {
                            ForEach(range, id: \.self) { index in
                                let day = month.days.at(index: index)
                                
                                Button {
                                    self.selectSelectedDay(newDay: day)
                                } label: {
                                    self.provider(day.calendarDay)
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .aspectRatio(7.0/6.0, contentMode: .fit)
                .frame(height: calendarViewHeight(geometry))
            }.gesture(DragGesture(minimumDistance: 20.0, coordinateSpace: .local).onEnded { value in
                let horizontalAmount = value.translation.width as CGFloat
                let verticalAmount = value.translation.height as CGFloat
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    if horizontalAmount < 0.0 {
                        self.selectPresentedDate(newDate: previous)
                    } else {
                        self.selectPresentedDate(newDate: next)
                    }
                }
            })
        }
    }
    
    private func calendarViewHeight(_ geometry: GeometryProxy) -> CGFloat {
        let cellWidth = ((geometry.size.width - (spacing * 6.0)) / 7.0)
        return cellWidth * CGFloat(ranges.count)
    }
    
    var header: some View {
        HStack {
            Button {
                self.selectPresentedDate(newDate: self.date.wrappedValue)
            } label: {
                Text(month.localizedName).bold()
            }.buttonStyle(PlainButtonStyle())
            Spacer()
            HStack {
                Button {
                    selectPresentedDate(newDate: previous)
                } label: {
                    Image(systemName: "chevron.left")
                        .offset(x: 10.0, y: 0)
                        .padding()
                }
                .keyboardShortcut(.leftArrow)
                .disabled(previous < dateRange.start)
                
                Button {
                    selectPresentedDate(newDate: next)
                } label: {
                    Image(systemName: "chevron.right")
                        .offset(x: 10.0, y: 0)
                        .padding()
                }
                .keyboardShortcut(.rightArrow)
                .disabled(next > dateRange.end)
            }.buttonStyle(PlainButtonStyle())
        }
    }
    
    private func selectSelectedDay(newDay: _Day) {
        withAnimation {
            if newDay.date < dateRange.start {
                self.date.wrappedValue = dateRange.start
            } else if newDay.date > dateRange.end {
                self.date.wrappedValue = dateRange.end
            } else {
                self.date.wrappedValue = newDay.date
            }
        }
        
        if !newDay.isMonth {
            self.selectPresentedDate(newDate: newDay.date)
        }
    }
    
    private func selectPresentedDate(newDate: Date) {
        UserInterface.feedback.selectionChanged()
        
        withAnimation {
            self.presented.wrappedValue = newDate
        }
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

extension Array where Element == _Day {
    func at(index: Int) -> _Day {
        guard index < self.count else {
            return _Day(date: Date.distantFuture, isMonth: false, isToday: false, day: 0)
        }
        return self[index]
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
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        guard let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var monthDayComponents = calendar.dateComponents([.month, .day, .year], from: monthInterval.start)
        monthDayComponents.day! += 42
        
        guard let endDate = calendar.date(from: monthDayComponents) else {
            return []
        }
        
        let interval = DateInterval(start: monthFirstWeek.start, end: endDate)
        
        return calendar._generate(datesWithin: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
}

public struct Week : Sequence, Identifiable {
    private let dates: [Date]
    
    public let id: Int
    
    fileprivate init(_ index: Int, _ dates: ArraySlice<Date>) {
        precondition(dates.count == 7)
        
        self.id = index
        self.dates = Array(dates)
    }
    
    public func makeIterator() -> some IteratorProtocol {
        return Array<Date>().makeIterator()
    }
    
    public func day(at index: Int) -> Date {
        return self.dates[index]
    }
}

extension Calendar {
    public func createWeeks(_ count: Int, fromStartDate startDate: Date) -> [Week]? {
        guard let startWeekInterval = self.dateInterval(of: .weekOfMonth, for: startDate) else {
            return nil
        }
        
        let expectedDays = count * 7
        
        var endDateComponents = self.dateComponents([.month, .day, .year], from: startWeekInterval.start)
        endDateComponents.day! += expectedDays
        
        guard let endDate = self.date(from: endDateComponents) else {
            return nil
        }
        
        let interval = DateInterval(start: startWeekInterval.start, end: endDate)
        
        let dates = self._generate(datesWithin: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
        
        guard dates.count == expectedDays else {
            return nil
        }
        
        var weeks = [Week]()
        
        for startIndex in (0..<count) {
            let lowerBound = startIndex * 7
            let upperBound = (startIndex * 7) + 7
            weeks.append(Week(startIndex, dates[lowerBound ..< upperBound]))
        }
        
        return weeks
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
    fileprivate func _generate(datesWithin interval: DateInterval, matching components: DateComponents) -> [Date] {
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
        CalendarPickerView(date: .constant(Date())) {
            SimpleCalendarDayView(day: $0)
        }.preferredColorScheme(.dark)
        
        CalendarPickerView(date: .constant(Date()), spacing: 8.0) {
            SimpleCalendarDayView(day: $0)
        }.preferredColorScheme(.light)
    }
}
