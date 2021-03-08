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
    
    public init(value: Value?, @ViewBuilder provider: @escaping (Value) -> Content) {
        self.value = value
        self.provider = provider
    }
    
    public var body: some View {
        if let value = self.value {
            return AnyView(self.provider(value))
        }
        return AnyView(EmptyView())
    }
}
