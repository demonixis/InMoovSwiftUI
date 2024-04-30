//
//  RobotSettings.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 29/04/2024.
//

import Foundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    private static let userDefaultKey = "settingsData"
        
    var settings: Settings = Settings()

    private init() {
        if let loaded = SettingsManager.loadSettingsData() {
            settings = loaded
        }
    }
    
    func saveSettingsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.settings) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.userDefaultKey)
        }
    }
    
    static func loadSettingsData() -> Settings? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: userDefaultKey),
           let decoded = try? decoder.decode(Settings.self, from: data) {
            return decoded;
        }
        
        return nil
    }
}

struct Settings: Codable {
    var openAIKey: String = ""
    var voiceRSSKey: String = ""
    var demoMode = false
    var speechLang: String = "en-US"
    var speechGender: String = "Male"
}
