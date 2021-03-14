//
//  InterfaceKit.swift
//
//
//  Created by Maddie Schipper on 3/4/21.
//

import SwiftUI

extension View {
    @inlinable public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    @inlinable public func enabled(_ enabled: Bool) -> some View {
        return self.disabled(!enabled)
    }
    
    @inlinable public func hidden(isHidden: Bool, removing: Bool = false) -> some View {
        if isHidden, removing {
            return EmptyView().eraseToAnyView()
        } else if isHidden {
            return self.hidden().eraseToAnyView()
        } else {
            return self.eraseToAnyView()
        }
    }
    
    @inlinable public func hidden(notHidden: Bool, removing: Bool = false) -> some View {
        return self.hidden(isHidden: !notHidden, removing: removing)
    }
    
    @inlinable public func hidden<V>(ifNil: V?, removing: Bool = false) -> some View {
        return self.hidden(isHidden: ifNil == nil, removing: removing)
    }
    
    @inlinable public func hidden<V>(ifNotNil: V?, removing: Bool = false) -> some View {
        return self.hidden(isHidden: ifNotNil != nil, removing: removing)
    }
}


public struct Interface {
}

#if canImport(Cocoa)
import Cocoa

extension Interface {
    @available(macOS 11, *)
    public static func toggleSidebar() {
        let responders = NSApp.keyWindow?.firstResponder?.allResponders.reversed() ?? []
        let selector = #selector(NSSplitViewController.toggleSidebar(_:))
        
        for responder in responders {
            if responder.responds(to: selector) {
                if responder.tryToPerform(selector, with: nil) {
                    break
                }
            }
        }
    }
}


extension NSResponder {
    public var allResponders: Array<NSResponder> {
        var chain = Array<NSResponder>()
        
        var responder: NSResponder? = self
        
        while let current = responder {
            chain.append(current)
            responder = current.nextResponder
        }
        
        return chain
    }
}

#endif
