//
//  SettingsView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 28/04/2024.
//

import SwiftUI
import Network

struct SettingsView: View {
    @ObservedObject private var settingsManager = SettingsManager.shared
    private let allBrains = BrainProviders.allCases
    
    var body: some View {
        Form {
            Section(header: Text("Speech Synthesis")) {
                Picker("Language", selection: $settingsManager.globalSettings.speechLang) {
                    ForEach(SystemLanguage.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                Picker("Gender", selection: $settingsManager.globalSettings.speechGender) {
                    ForEach(SystemGender.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            
            Section(header: Text("Brain")) {
                Picker("AI Provider", selection: $settingsManager.globalSettings.brainProvider) {
                    ForEach(allBrains, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
            
            Section(header: Text("Options")) {
                Toggle("Demo Mode", isOn: $settingsManager.globalSettings.demoMode)
            }
            
            Section(header: Text("API Keys")) {
                TextField("OpenAI Key", text: $settingsManager.globalSettings.openAIKey)
                TextField("VoiceRSS Key", text: $settingsManager.globalSettings.voiceRSSKey)
                TextField("Eleven Labs Key", text: $settingsManager.globalSettings.elevenLabKey)
            }
        }
        .navigationBarTitle("Settings")
        .navigationBarItems(trailing: Button("Save") {
            saveSettings()
        })
    }
    
    private func saveSettings() {
        settingsManager.saveAppSettings()
    }
}

#Preview {
    SettingsView()
}
