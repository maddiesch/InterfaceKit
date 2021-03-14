//
//  BaseViewModel.swift
//  
//
//  Created by Maddie Schipper on 3/13/21.
//

import Foundation
import Combine

open class BaseViewModel : ObservableObject {
    public var observers = Set<AnyCancellable>()
    
    public init() {
        
    }
    
    public func cancel() {
        self.observers.cancelAll()
    }
    
    deinit {
        self.cancel()
    }
}

extension Set where Element == AnyCancellable {
    public mutating func cancelAll() {
        for canceler in self {
            canceler.cancel()
        }
        
        self.removeAll()
    }
}
