//
//  historyModel.swift
//  ClipboardHistory
//
//  Created by Yu Cao on 12/14/24.
//

import Foundation

struct HistoryModel: Identifiable {
    let id = UUID()
    var content: String
    var date: Date
}
