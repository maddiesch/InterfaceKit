//
//  File.swift
//  
//
//  Created by Maddie Schipper on 4/4/21.
//

#if canImport(UIKit)

import SwiftUI
import UIKit

public struct VisualEffectView : UIViewRepresentable {
    public var effect: UIVisualEffect?
    
    public init(effect: UIVisualEffect?) {
        self.effect = effect
    }
    
    public typealias UIViewType = UIVisualEffectView
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: self.effect)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = self.effect
    }
}

#endif
