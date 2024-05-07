//
//  BrainData.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 03/05/2024.
//

import Foundation

enum BrainProviders: UInt8, CaseIterable, Identifiable, Codable {
    case OpenAI = 1
    
    var id: UInt8 {
        return self.rawValue
    }
}

enum TTSProviders: Int, CaseIterable, Identifiable, Codable {
    case System = 1
    
    var id: Int {
        return self.rawValue
    }
}

enum SystemLanguage: String, CaseIterable, Identifiable, Codable {
    case french = "fr-FR"
    case english = "en-US"
    
    var id: String {
        return self.rawValue
    }
}

enum SystemGender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    
    var id: String {
        return self.rawValue
    }
}
