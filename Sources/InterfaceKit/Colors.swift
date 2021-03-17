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
