//
//  QuickLookPreviewView.swift
//  
//
//  Created by Maddie Schipper on 3/14/21.
//

import SwiftUI
import QuickLook

#if os(macOS)

import Cocoa
import Quartz

public struct QuickLookPreviewView : View {
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    public var body: some View {
        _QuickLookPreviewView(fileURL: self.fileURL)
    }
}

fileprivate struct _QuickLookPreviewView : NSViewRepresentable {
    public typealias NSViewType = QLPreviewView
    
    private let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func makeNSView(context: Context) -> QLPreviewView {
        guard let view = QLPreviewView(frame: .zero, style: .normal) else {
            fatalError("Failed to create a valid preview view")
        }
        
        view.autostarts = true
        view.previewItem = self.fileURL as QLPreviewItem
        
        return view
    }
    
    func updateNSView(_ nsView: QLPreviewView, context: Context) {
        
    }
    
    static func dismantleNSView(_ nsView: QLPreviewView, coordinator: ()) {
        nsView.close()
    }
}

#endif
