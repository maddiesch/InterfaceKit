//
//  ApplicationViewModel.swift
//  Dumpy
//
//  Created by Maddie Schipper on 4/4/21.
//

import Foundation
import Combine
import CoreData

public typealias AnyCancellable = Combine.AnyCancellable
public typealias ManagedObjectContext = CoreData.NSManagedObjectContext

open class ApplicationViewModel : ObservableObject, ViewLifecycleTracker {
    public let context: ManagedObjectContext
    
    public init(_ context: ManagedObjectContext) {
        self.context = context
    }
    
    deinit {
        self.cancel()
    }
    
    private var _observers = Set<AnyCancellable>()
    
    open func beginObservingChanges(withObservers observers: inout Set<AnyCancellable>) {}
    
    open func willAppear() {}
    
    open func willDisappear() {}
    
    public func cancel() {
        self._observers.cancelAll()
    }
    
    public func onAppear() {
        self.willAppear()
        self.beginObservingChanges(withObservers: &_observers)
    }
    
    public func onDisappear() {
        self.willDisappear()
        self.cancel()
    }
}
