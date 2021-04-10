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

extension Color {
    public init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else {
            return nil
        }
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
