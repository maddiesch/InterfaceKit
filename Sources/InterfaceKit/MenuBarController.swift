//
//  MenuBarAppHost.swift
//  
//
//  Created by Maddie Schipper on 4/7/21.
//


#if os(macOS)
import SwiftUI

public final class MenuBarController : NSObject {
    private let popover: NSPopover
    private let statusBarItem: NSStatusItem
    fileprivate var eventMonitor: EventMonitor?
    
    public init<Content : View>(contentView: Content, contentSize: NSSize = NSSize(width: 200.0, height: 300.0)) {
        self.popover = NSPopover()
        self.popover.contentSize = contentSize
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: contentView)
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        super.init()
        
        if let button = self.statusBarItem.button {
            button.target = self
            button.action = #selector(togglePopover(_:))
        }
    }
    
    public func configureMenuBarButton(_ block: (NSStatusBarButton) -> Void) {
        guard let button = self.statusBarItem.button else {
            return
        }
        
        block(button)
    }
    
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = self.statusBarItem.button else {
            return
        }
        
        if self.popover.isShown {
            self.popover.performClose(sender)
            self.eventMonitor = nil
        } else {
            self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: togglePopover(_:))
            self.eventMonitor?.start()
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            self.popover.contentViewController?.view.window?.becomeKey()
        }
    }
}

fileprivate class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
      self.mask = mask
      self.handler = handler
    }

    deinit {
        self.stop()
    }

    public func start() {
        self.stop()
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    public func stop() {
        if let monitor = self.monitor {
            NSEvent.removeMonitor(monitor)
        }
        self.monitor = nil
    }
}

#endif
