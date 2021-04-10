//
//  PillView.swift
//  
//
//  Created by Maddie Schipper on 3/13/21.
//

import SwiftUI

public struct PillView<Content : View> : View {
    private let content: Content
    
    private let color: Color
    
    private let edgePadding: EdgeInsets
    
    public init(color: Color = .secondary, edgePadding: EdgeInsets = EdgeInsets(top: 0, leading: 4.0, bottom: 0, trailing: 4.0), @ViewBuilder content: () -> Content) {
        self.content = content()
        self.color = color
        self.edgePadding = edgePadding
    }
    
    public var body: some View {
        self.content.colorInvert().padding(self.edgePadding).background(Capsule().fill(self.color))
    }
}
