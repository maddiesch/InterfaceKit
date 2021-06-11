//
//  PlatformView.swift
//  
//
//  Created by Maddie Schipper on 3/17/21.
//

import SwiftUI

public enum Platform {
    #if os(macOS)
    public static let current = Platform.macOS
    #else
    public static let current = Platform.iOS
    #endif
    
    case macOS
    case iOS
}

public struct PlatformView<Content : View> : View {
    private let platform: Platform
    private let content: () -> Content
    
    public init(platform: Platform, @ViewBuilder content: @escaping () -> Content) {
        self.platform = platform
        self.content = content
    }
    
    public var body: some View {
        if platform == Platform.current {
            self.content()
        } else {
            EmptyView()
        }
    }
}
