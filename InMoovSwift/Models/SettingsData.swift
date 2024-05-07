//
//  SettingsData.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 06/05/2024.
//

import Foundation

struct Settings: Codable {
    var openAIKey: String = ""
    var voiceRSSKey: String = ""
    var elevenLabKey: String = ""
    var demoMode = false
    var speechLang: SystemLanguage = .english
    var speechGender: SystemGender = .male
    var brainProvider: BrainProviders = .OpenAI
    var ttsProvder: TTSProviders = .System
}
