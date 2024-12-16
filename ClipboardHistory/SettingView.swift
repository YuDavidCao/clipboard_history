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
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    ForEach(clipboardMonitor.history.indices, id: \.self) { index in
                        let entry = clipboardMonitor.history[index]
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
            } else {
                VStack (alignment: .leading) {
                    Button (action: {
                        showingAlert = true
                    } ) {
                        HStack {
                            Text("Clear History")
                            Image(
                                systemName: "trash"
                            ).foregroundStyle(Color.red)
                        }
                    }.alert("Clear History", isPresented: $showingAlert) {
                        Button("OK", role: .none) {
                            clipboardMonitor.history.removeAll()
                        }
                        Button("Cancel", role: .cancel) {
                        }
                    } message: {
                        Text("This is an alert message.")
                    }
                    Toggle(isOn: $settingManager.hideDateTime) {
                        Text("Hide date & time for history")
                    }.toggleStyle(SwitchToggleStyle())
                        .onChange(of: settingManager.hideDateTime) {
                            settingManager.onHideDateTimeToggle(newValue: settingManager.hideDateTime)
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
