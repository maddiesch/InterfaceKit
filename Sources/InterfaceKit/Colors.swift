//
//  Colors.swift
//  
//
//  Created by Maddie Schipper on 3/16/21.
//

import SwiftUI

extension Color {
    #if os(macOS)
    public static let background = Color(NSColor.windowBackgroundColor)
    public static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    public static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    public static let separator = Color(NSColor.separatorColor)
    #else
    public static let background = Color(UIColor.systemBackground)
    public static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    public static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    public static let separator = Color(UIColor.separator)
    #endif
}

#if os(macOS)
public typealias IFKColor = NSColor
#else
public typealias IFKColor = UIColor
#endif

extension IFKColor {
    public convenience init?(named name: String, in bundle: Bundle?) {
        #if os(macOS)
        self.init(named: name, bundle: bundle)
        #else
        self.init(named: name, in: bundle, compatibleWith: nil)
        #endif
    }
}
