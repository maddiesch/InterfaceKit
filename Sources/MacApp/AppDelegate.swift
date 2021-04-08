//
//  AppDelegate.swift
//  
//
//  Created by Maddie Schipper on 4/6/21.
//

import AppKit
import SwiftUI

class AppDelegate : NSObject, NSApplicationDelegate {
    let window = NSWindow(
        contentRect: NSRect(origin: .zero, size: .zero),
        styleMask: [.closable, .titled, .resizable],
        backing: .buffered,
        defer: false
    )
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        do {
            let appMenu = NSMenuItem()
            appMenu.submenu = NSMenu()
            appMenu.submenu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            let menu = NSMenu()
            menu.addItem(appMenu)
            
            NSApplication.shared.mainMenu = menu
        }
        
        self.window.contentView = NSHostingView(rootView: AppView())
        self.window.center()
        self.window.makeKeyAndOrderFront(nil)
        
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
