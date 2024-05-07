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
    private static let servoStoreKey = "servosData"
        
    @Published var globalSettings: Settings = Settings() {
        didSet {
            saveAppSettings()
        }
    }
    
    @Published var devBoardData: [DevBoardData] = [] {
        didSet {
            saveDevBoardData()
        }
    }
    
    @Published var servosData: [ServoData] = [] {
        didSet {
            saveServosData()
        }
    }

    private init() {
        if let loaded = SettingsManager.loadAppSettings() {
            globalSettings = loaded
        }
        
        if let cards = SettingsManager.loadDevBoardData() {
            devBoardData = cards;
        }
        
        if let servos = SettingsManager.loadServosData() {
            servosData = servos
        }
    }
    
    func saveAppSettings() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.globalSettings) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.userDefaultKey)
        }
    }
    
    func saveDevBoardData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.devBoardData) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.cardDataKey)
        }
    }
    
    func saveServosData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(servosData) {
            UserDefaults.standard.set(encoded, forKey: SettingsManager.servoStoreKey)
        }
    }
    
    static func loadAppSettings() -> Settings? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: userDefaultKey),
           let decoded = try? decoder.decode(Settings.self, from: data) {
            return decoded;
        }
        
        return nil
    }
    
    static func loadDevBoardData() -> [DevBoardData]? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: cardDataKey),
           let decoded = try? decoder.decode([DevBoardData].self, from: data) {
            return decoded
        }
        
        return nil
    }
    
    static func loadServosData() -> [ServoData]? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: servoStoreKey),
           let decoded = try? decoder.decode([ServoData].self, from: data) {
            return decoded
        }
        return nil
    }
}
