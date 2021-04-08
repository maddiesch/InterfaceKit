//
//  CalendarPickerContainerView.swift
//  
//
//  Created by Maddie Schipper on 4/6/21.
//

import SwiftUI
import InterfaceKit

struct CalendarPickerContainerView : View {
    @Environment(\.calendar) var calendar
    
    @State var selectedDate = Date()
    
    var body: some View {
        CalendarPickerView(date: $selectedDate) { day in
            SimpleCalendarDayView(day: day)
        }.border(Color.red)
    }
}
