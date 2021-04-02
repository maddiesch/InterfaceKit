//
//  RoundedBorderViewModifier.swift
//
//
//  Created by Maddie Schipper on 3/14/21.
//

import SwiftUI

public struct RoundedBorderViewModifier : ViewModifier {
    public let cornerRadius: CGFloat
    public let lineWidth: CGFloat
    public let lineColor: Color
    public let innerPadding: EdgeInsets
    
    public init(cornerRadius: CGFloat = 10.0, lineWidth: CGFloat = 1.0, lineColor: Color = Color.secondary.opacity(0.7), innerPadding: EdgeInsets = EdgeInsets(top: 2.0, leading: 4.0, bottom: 2.0, trailing: 4.0)) {
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.innerPadding = innerPadding
    }
    
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: self.cornerRadius)
        let overlay = shape.stroke(self.lineColor, lineWidth: self.lineWidth)
        
        return content.overlay(overlay).padding(lineWidth / 2.0).clipShape(shape)
    }
}

public struct CircularBorderViewModifier : ViewModifier {
    public let lineWidth: CGFloat
    public let lineColor: Color
    
    public init(lineWidth: CGFloat = 1.0, lineColor: Color = Color.secondary.opacity(0.7)) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
    public func body(content: Content) -> some View {
        let shape = Circle()
        return content.overlay(shape.stroke(self.lineColor, lineWidth: self.lineWidth)).padding(lineWidth / 2.0).clipShape(shape)
    }
}

