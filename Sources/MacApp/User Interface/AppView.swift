//
//  AppView.swift
//  
//
//  Created by Maddie Schipper on 4/6/21.
//

import SwiftUI

struct AppView : View {
    var body: some View {
        _ContainerView()
    }
}

fileprivate struct _ContainerView : View {
    @AppStorage("AppView.SelectedTab") var selectedTabID = 0
    
    var body: some View {
        TabView(selection: $selectedTabID) {
            CalendarPickerContainerView().tabItem {
                Text("Calendar")
            }.tag(0)
            
            Text("View 2").tabItem { Text("View 2") }.tag(1)
        }
    }
}
