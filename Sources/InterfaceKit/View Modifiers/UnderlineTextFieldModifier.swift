//
//  UnderlineTextFieldModifier.swift
//  
//
//  Created by Maddie Schipper on 3/14/21.
//

import SwiftUI

public struct UnderlineTextFieldModifier : ViewModifier {
    public let underlineColor: Color?
    public let underlineSpacing: CGFloat
    
    public init(underlineColor: Color? = nil, underlineSpacing: CGFloat = 2.0) {
        self.underlineColor = underlineColor
        self.underlineSpacing = underlineSpacing
    }
    
    public func body(content: Content) -> some View {
        return VStack(spacing: self.underlineSpacing) {
            content.textFieldStyle(PlainTextFieldStyle())
            Divider().background(self.underlineColor)
        }
    }
}
