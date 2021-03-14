//
//  EnvironmentObjectProviderView.swift
//  
//
//  Created by Maddie Schipper on 3/13/21.
//

import SwiftUI

public struct EnvironmentObjectProviderView<Object : ObservableObject, Content : View> : View {
    @EnvironmentObject private var object: Object
    
    private let content: (Object) -> Content
    
    public init(objectType: Object.Type, @ViewBuilder content: @escaping (Object) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        return self.content(object)
    }
}
