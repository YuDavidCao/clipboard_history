//
//  SettingManager.swift
//  ClipboardHistory
//
//  Created by Yu Cao on 12/16/24.
//

import SwiftUI

class SettingManager: ObservableObject {
        
    @Published var hideDateTime: Bool = {
        UserDefaults.standard.bool(forKey: hideDateTimeKey)
    }()
    
    public func onHideDateTimeToggle(newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: hideDateTimeKey)
        hideDateTime = newValue
    }
    
}
