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

open class BaseApplicationViewModel : ObservableObject, ViewLifecycleTracker {
    public init() {}
    
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
    
    public func beginObservingChanges() {
        self.willBeginObservingChanges()
        self.beginObservingChanges(withObservers: &_observers)
    }
    
    open func willBeginObservingChanges() {}
    
    public func onAppear() {
        self.willAppear()
        
        self.beginObservingChanges()
    }
    
    public func onDisappear() {
        self.willDisappear()
        self.cancel()
    }
}

@available(*, deprecated, renamed: "ContextApplicationViewModel")
typealias ApplicationViewModel = ContextApplicationViewModel

public typealias ManagedObjectContext = CoreData.NSManagedObjectContext

open class ContextApplicationViewModel : BaseApplicationViewModel {
    public let context: ManagedObjectContext
    
    public init(_ context: ManagedObjectContext) {
        self.context = context
    }
}
