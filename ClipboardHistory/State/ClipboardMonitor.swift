//
//  ClipboardMinitor.swift
//  ClipboardHistory
//
//  Created by Yu Cao on 12/14/24.
//
import AppKit
import Cocoa
import Combine

class ClipboardMonitor: ObservableObject {
    @Published var history: [HistoryModel] = []
    
    private let pasteboard = NSPasteboard.general
    private var changeCount: Int
    
    init() {
        print("Client started")
        changeCount = pasteboard.changeCount
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            self.handleKeyEvent(event)
        }
        startMonitoring()
    }
    
    private func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        if pasteboard.changeCount != changeCount {
            changeCount = pasteboard.changeCount
            if let newContent = pasteboard.string(forType: .string) {
                let newEntry = HistoryModel(content: newContent, date: Date())
                DispatchQueue.main.async {
                    if(self.history.isEmpty || self.history[0].content != newEntry.content) {
                        self.history.insert(newEntry, at: 0)

                    }
                }
            }
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        let flags = event.modifierFlags
        let keyCode: UInt16 = event.keyCode
        let index: Int = Int(keyCode) - 18
        
        if flags.contains(.control) && (keyCode >= 18 && keyCode <= 26) {
            if(index < history.count) {
                DispatchQueue.main.async {
                    print("Ctrl + \(keyCode) Detected: pasting clipboard content \(self.history[index].content)")
                    self.pasteClipboardContent(index: index)
                }
            }
        }
    }
    
    func pasteClipboardContent(index: Int) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(history[index].content, forType: .string)
        
        // Simulate CMD+V keystroke
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Create keydown event for Command key (0x37)
        let cmdKeyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
        // Create keydown event for V key
        let vKeyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        // Create keyup event for V key
        let vKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        // Create keyup event for Command key
        let cmdKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)
        
        // Set flags for command key
        vKeyDown?.flags = .maskCommand
        vKeyUp?.flags = .maskCommand
        
        // Post the events
        cmdKeyDown?.post(tap: .cghidEventTap)
        vKeyDown?.post(tap: .cghidEventTap)
        vKeyUp?.post(tap: .cghidEventTap)
        cmdKeyUp?.post(tap: .cghidEventTap)
    }
}
