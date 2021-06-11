//
//  InterfaceKit.swift
//
//
//  Created by Maddie Schipper on 3/4/21.
//

import SwiftUI

extension View {
    @available(*, deprecated, message: "AnyView should be a last resport as it removes type information from the runtime & compiler for optimizations.")
    @inlinable public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    @inlinable public func isLoading(_ loading: Bool) -> some View {
        return self.redacted(reason: loading ? .placeholder : [])
    }
    
    @inlinable public func enabled(_ enabled: Bool) -> some View {
        return self.disabled(!enabled)
    }
    
    @inlinable
    @ViewBuilder
    public func hide(if isHidden: Bool, removing: Bool = false) -> some View {
        if isHidden, removing {
            EmptyView().transition(.opacity)
        } else if isHidden {
            self.hidden().transition(.opacity)
        } else {
            self.transition(.opacity)
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

@available(*, deprecated, renamed: "UserInterface")
public typealias Interface = UserInterface

public struct UserInterface {
    public static let feedback = FeedbackGenerator()
}

extension UserInterface {
    public static func toggleSidebarAction() {
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
    
    @available(*, deprecated, renamed: "toggleSidebarAction")
    public static func toggleSidebar() {
        self.toggleSidebarAction()
    }
}

public struct FeedbackGenerator {
    #if os(iOS)
    public typealias FeedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle
    public typealias FeedbackType = UINotificationFeedbackGenerator.FeedbackType
    
    public func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    public func impactOccurred(_ style: FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    public func notificationOccurred(_ style: FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(style)
    }
    
    #else
    
    public enum FeedbackStyle {
        case light
        case medium
        case heavy
        case soft
        case rigid
    }
    
    public enum FeedbackType {
        case success
        case warning
        case error
    }
    
    public func selectionChanged() {}
    
    public func impactOccurred(_ style: FeedbackStyle) {}
    
    public func notificationOccurred(_ style: FeedbackType) {}
    
    #endif
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
