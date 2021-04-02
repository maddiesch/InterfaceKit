//
//  CenterViewModifier.swift
//  
//
//  Created by Maddie Schipper on 3/16/21.
//

import SwiftUI

public struct CenterViewModifier : ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        return VStack {
            Spacer(minLength: 0.0)
            HStack {
                Spacer(minLength: 0.0)
                content
                Spacer(minLength: 0.0)
            }
            Spacer(minLength: 0.0)
        }
    }
}
