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
