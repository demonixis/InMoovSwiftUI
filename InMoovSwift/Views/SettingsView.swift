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
    @ObservedObject private var bluetoothManager = BluetoothManager.shared
    @State private var selectedVoiceLanguage = "en-US"
    @State private var selectedGenderIndex = 0
    private let genderOptions = ["Male", "Female"]
    private let voiceLanguages = [
        "en-US",
        "fr-FR"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Connection")) {
                HStack {
                    Text("Bluetooth \(bluetoothManager.isConnected ? "Connected" : "Disconnected")")

                    Spacer()
                    Button("\(bluetoothManager.isConnected ? "Disconnect" : "Connect")") {
                        if (bluetoothManager.isConnected) {
                            bluetoothManager.disconnect()
                        } else {
                            bluetoothManager.connect()
                        }
                    }
                    
                    Spacer()
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(bluetoothManager.isConnected ? .green : .red)
                }
            }
            
            Section(header: Text("API Keys")) {
                TextField("OpenAI Key", text: $settingsManager.settings.openAIKey)
                TextField("VoiceRSS Key", text: $settingsManager.settings.voiceRSSKey)
            }
            
            Section(header: Text("Speech Synthesis")) {
                Picker("Language", selection: $selectedVoiceLanguage) {
                    ForEach(voiceLanguages, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Gender", selection: $selectedGenderIndex) {
                    ForEach(0..<genderOptions.count, id: \.self) {
                        Text(self.genderOptions[$0])
                    }
                }
            }
            
            Section(header: Text("Options")) {
                Toggle("Demo Mode", isOn: $settingsManager.settings.demoMode)
            }
        }
        .navigationBarTitle("Settings")
        .navigationBarItems(trailing: Button("Save") {
            saveSettings()
        })
    }
    
    private func saveSettings() {
        settingsManager.saveSettingsData()
    }
}

#Preview {
    SettingsView()
}
