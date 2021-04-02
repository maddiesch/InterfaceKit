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
    
    @inlinable public func hide(if isHidden: Bool, removing: Bool = false) -> some View {
        if isHidden, removing {
            return EmptyView().transition(.opacity).eraseToAnyView()
        } else if isHidden {
            return self.hidden().transition(.opacity).eraseToAnyView()
        } else {
            return self.transition(.opacity).eraseToAnyView()
        }
    }
    
    @inlinable public func hide(unless: Bool, removing: Bool = false) -> some View {
        return self.hide(if: !unless, removing: removing)
    }
    
    @inlinable public func hide<V>(if optional: V?, removing: Bool = false) -> some View {
        return self.hide(if: optional == nil, removing: removing)
    }
    
    @inlinable public func hide<V>(unless optional: V?, removing: Bool = false) -> some View {
        return self.hide(if: optional != nil, removing: removing)
    }
    
    @available(*, deprecated, message: "Use 'hide' instead")
    @inlinable public func hidden(isHidden: Bool, removing: Bool = false) -> some View {
        return self.hide(if: isHidden, removing: removing)
    }
    
    @available(*, deprecated, message: "Use 'hide' instead")
    @inlinable public func hidden(notHidden: Bool, removing: Bool = false) -> some View {
        return self.hide(unless: notHidden, removing: removing)
    }
    
    @available(*, deprecated, message: "Use 'hide' instead")
    @inlinable public func hidden<V>(ifNil: V?, removing: Bool = false) -> some View {
        return self.hidden(isHidden: ifNil == nil, removing: removing)
    }
    
    @available(*, deprecated, message: "Use 'hide' instead")
    @inlinable public func hidden<V>(ifNotNil: V?, removing: Bool = false) -> some View {
        return self.hidden(isHidden: ifNotNil != nil, removing: removing)
    }
}


public struct Interface {
}

extension Interface {
    public static func toggleSidebar() {
        #if os(macOS)
        let responders = NSApp.keyWindow?.firstResponder?.allResponders.reversed() ?? []
        let selector = #selector(NSSplitViewController.toggleSidebar(_:))
        
        for responder in responders {
            if responder.responds(to: selector) {
                if responder.tryToPerform(selector, with: nil) {
                    break
                }
            }
        }
        #endif
    }
}


#if os(macOS)

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
