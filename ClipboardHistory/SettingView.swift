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
    @EnvironmentObject var settingManager: SettingManager
    
    //    @StateObject var clipboardMonitor: ClipboardMonitor
    //    = ClipboardMonitor()
    //    @StateObject var settingManager: SettingManager = SettingManager()
    
    @State var select: Int = -1
    @State var showSetting: Bool = false
    @State private var showClearHistoryAlert = false
    @State private var showQuitAlert = false
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    TextField("Search", text: $searchString).textFieldStyle(.roundedBorder)
                    ForEach(clipboardMonitor.history.indices, id: \.self) { index in
                        let entry = clipboardMonitor.history[index]
                        if searchString == "" || entry.content.contains(searchString) {
                            Button (
                                action: {
                                    select = index
                                    showSetting = false
                                }
                            ) {
                                VStack(alignment: .leading) {
                                    if !settingManager.hideDateTime {
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
                                    } else {
                                        HStack {
                                            Text(entry.content)
                                                .font(.headline).frame(
                                                    
                                                    alignment: .leading
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
                        
                        
                    }
                }
                Divider()
                HStack {
                    Text("Setting").padding()
                    Image(systemName: "gear").padding()
                }.onTapGesture {
                    showSetting = true
                }
            }
            .navigationTitle("Clipboard History")
            if !showSetting && select >= 0 {
                VStack (alignment: .leading) {
                    ScrollView {
                        Text(clipboardMonitor.history[select].content)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
                            .frame(maxHeight: .infinity, alignment: .topLeading).textSelection(.enabled)
                    }
                    Spacer()
                    Divider()
                    if select < 8{
                        HStack {
                            Image(systemName: "document.on.document").onTapGesture {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(clipboardMonitor.history[select].content, forType: .string)
                            }.padding(
                                EdgeInsets(
                                    top: 2, leading: 2, bottom: 2, trailing: 2
                                )
                            )
                            Spacer()
                            Text("Copy command:").font(.caption)
                            Image(systemName: "control")
                            Text(String(select + 1))
                        }.padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 8))
                    }
                    HStack {
                        Spacer()
                        Text(clipboardMonitor.history[select].date, style: .date) // Display date
                        Text(clipboardMonitor.history[select].date, style: .time) // Display time
                            .padding(
                                EdgeInsets(top: 4, leading: 4, bottom: 8, trailing: 8)
                            )
                    }.font(.caption)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            } else {
                VStack (alignment: .leading) {
                    HStack {
                        Spacer()
                        Text("Setting").font(.headline)
                        Spacer()
                    }
                    Divider()
                    Button (action: {
                        showQuitAlert = true
                    } ) {
                        HStack {
                            Text("Quit").frame(maxWidth: .infinity)
                            Image(
                                systemName: "xmark.circle"
                            ).foregroundStyle(Color.red)
                        }
                    }.alert("Quit", isPresented: $showQuitAlert) {
                        Button("OK", role: .none) {
                            NSApplication.shared.terminate(nil)
                        }
                        Button("Cancel", role: .cancel) {
                        }
                    } message: {
                        Text("Are you sure you want to quit?")
                    }
                    Button (action: {
                        showClearHistoryAlert = true
                    } ) {
                        HStack {
                            Text("Clear History").frame(maxWidth: .infinity)
                            Image(
                                systemName: "trash"
                            ).foregroundStyle(Color.red)
                        }
                    }.alert("Clear History", isPresented: $showClearHistoryAlert) {
                        Button("OK", role: .none) {
                            clipboardMonitor.history.removeAll()
                        }
                        Button("Cancel", role: .cancel) {
                        }
                    } message: {
                        Text("Are you sure you want to clear history?")
                    }
                    Toggle(isOn: $settingManager.hideDateTime) {
                        Text("Hide date & time for history")
                    }.toggleStyle(SwitchToggleStyle())
                        .onChange(of: settingManager.hideDateTime) {
                            settingManager.onHideDateTimeToggle(newValue: settingManager.hideDateTime)
                        }
                    Divider()
                    Text("Copy Hotkey: ").padding(
                        EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
                    )
                    HStack {
                        Image (systemName: "control")
//                        Image (systemName: "plus")
                        Text("<number>")
                    }
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading).padding()
            }
        }
    }
}


#Preview {
    SettingView()
}
