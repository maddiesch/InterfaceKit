//
//  ViewLifecycleTracker.swift
//  
//
//  Created by Maddie Schipper on 3/15/21.
//

import SwiftUI

public protocol ViewLifecycleTracker {
    func onAppear()
    func onDisappear()
}

extension ViewLifecycleTracker {
    public func onAppear() {}
    public func onDisappear() {}
}

extension View {
    @inlinable
    public func trackLifecycle(_ tracker: ViewLifecycleTracker) -> some View {
        return self.onAppear(perform: tracker.onAppear).onDisappear(perform: tracker.onDisappear)
    }
}
