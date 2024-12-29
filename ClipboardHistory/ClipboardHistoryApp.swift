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
        WindowGroup{
                EmptyView()
                    .frame(width: 0, height: 0)
                    .hidden()
            }
            .windowResizability(.contentSize)
        }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    let popover = NSPopover()
    
    @StateObject private var clipboardMonitor: ClipboardMonitor;
    @StateObject private var settingManager: SettingManager;
    
    override init() {
        _clipboardMonitor = StateObject(wrappedValue: ClipboardMonitor())
        _settingManager = StateObject(wrappedValue: SettingManager())
    }
    
    func getClipboardMonitor() -> ClipboardMonitor {
        return clipboardMonitor
    }
    
    func getSettingManager() -> SettingManager {
        return settingManager
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared.windows.first {
                window.close()
        }
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "clipboard.fill", accessibilityDescription: "Settings")
            button.action = #selector(togglePopover)
        }
        
        // Configure the popover's content view
        let contentView = NSHostingView(rootView: SettingView().environmentObject(clipboardMonitor).environmentObject(settingManager))
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
