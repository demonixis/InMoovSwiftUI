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
    private static let cardDataKey = "cardsData"
        
    @Published var globalSettings: Settings = Settings() {
        didSet {
            saveSettingsData()
        }
    }
    
    @Published var devBoardData: [DevelopmentBoard] = [] {
        didSet {
            saveCardData()
        }
    }

    private init() {
        if let loaded = SettingsManager.loadSettingsData() {
            globalSettings = loaded
        }
        
        if let cards = SettingsManager.loadCardData() {
            devBoardData = cards;
        }
    }
    
    func saveSettingsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.globalSettings) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.userDefaultKey)
        }
    }
    
    func saveCardData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.devBoardData) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.cardDataKey)
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
    
    static func loadCardData() -> [DevelopmentBoard]? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: cardDataKey),
           let decoded = try? decoder.decode([DevelopmentBoard].self, from: data) {
            return decoded
        }
        
        return nil
    }
}

struct Settings: Codable {
    var openAIKey: String = ""
    var voiceRSSKey: String = ""
    var elevenLabKey: String = ""
    var demoMode = false
    var speechLang: String = "en-US"
    var speechGender: String = "Male"
    var brainProvider: BrainProviders = .OpenAI
}
