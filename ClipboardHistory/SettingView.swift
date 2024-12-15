//
//  SettingView.swift
//  ClipboardHistory
//
//  Created by Yu Cao on 12/15/24.
//

import SwiftUI
import Cocoa

struct SettingView: View {
    
    @EnvironmentObject var clipboardMonitor: ClipboardMonitor
    
    
    @State var select: Int = -1;
    
    var body: some View {
        NavigationView {
            List {
                ForEach(clipboardMonitor.history.indices, id: \.self) { index in
                    let entry = clipboardMonitor.history[index]
                    Button (
                        action: {
                            select = index
                        }
                    ) {
                        VStack(alignment: .leading) {
                            Text(entry.content)
                                .font(.headline).frame(
                                    
                                    alignment: .leading
                                )
                            HStack {
                                Text(entry.date, style: .time)
                                    .font(.subheadline)
                                    .foregroundColor(.gray).frame(
                                        minWidth: 0,
                                        maxWidth: .infinity, alignment: .leading
                                    )
                                Spacer()
                                Button (
                                    action: {
                                        clipboardMonitor.history.remove(at: index)
                                        if(index == select) {
                                            select = -1
                                        }
                                    }
                                ) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            .navigationTitle("Clipboard History")
            if select >= 0 {
                VStack (alignment: .leading) {
                    ScrollView {
                        Text(clipboardMonitor.history[select].content)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
                            .frame(maxHeight: .infinity, alignment: .topLeading).textSelection(.enabled)
                    }
                    Spacer()
                    Divider()
                    HStack {
                        Spacer()
                        Text(clipboardMonitor.history[select].date, style: .date) // Display date
                        Text(clipboardMonitor.history[select].date, style: .time) // Display time
                            .padding(
                                EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 8)
                            )
                    }.font(.subheadline)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
    }
}
