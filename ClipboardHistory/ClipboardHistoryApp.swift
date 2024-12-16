//
//  ClipboardHistoryApp.swift
//  ClipboardHistory
//
//  Created by Yu Cao on 12/14/24.
//

import SwiftUI
import AppKit

@main
struct MenuTestApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SettingView().environmentObject(appDelegate.clipboardMonitor).environmentObject(appDelegate.settingManager)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    let popover = NSPopover()
    
    @StateObject var clipboardMonitor = ClipboardMonitor()
    @StateObject var settingManager = SettingManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "Settings")
            button.action = #selector(togglePopover)
        }
        
        // Configure the popover's content view
        let contentView = NSHostingView(rootView: ContentView().environmentObject(clipboardMonitor).environmentObject(settingManager))
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = contentView
        popover.behavior = .transient  // Important: Makes popover disappear on outside click
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusBarItem?.button {
                // Show popover aligned to the status bar button's lower-left corner
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                
                // Focus the popover (optional, but improves user experience)
                popover.contentViewController?.view.window?.makeFirstResponder(popover.contentViewController?.view)
            }
            
        }
    }
    
}
