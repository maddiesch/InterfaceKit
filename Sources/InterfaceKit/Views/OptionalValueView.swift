//
//  OptionalValueView.swift
//  
//
//  Created by Maddie Schipper on 3/6/21.
//

import SwiftUI

public struct OptionalValueView<Content : View, Value> : View {
    var provider: (Value) -> Content
    
    var value: Value?
    var noValueView: AnyView
    
    public init<V : View>(value: Value?, @ViewBuilder provider: @escaping (Value) -> Content, @ViewBuilder fallback: () -> V) {
        self.init(value: value, noValue: AnyView(fallback()), provider: provider)
    }
    
    public init(value: Value?, noValue: AnyView? = nil, @ViewBuilder provider: @escaping (Value) -> Content) {
        self.value = value
        self.provider = provider
        if let noValue = noValue {
            self.noValueView = noValue
        } else {
            self.noValueView = AnyView(EmptyView())
        }
    }
    
    public var body: some View {
        if let value = self.value {
            self.provider(value)
        } else {
            self.noValueView
        }
    }
}
