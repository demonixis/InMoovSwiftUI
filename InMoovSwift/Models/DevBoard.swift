//
//  DevelopmentBoard.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 06/05/2024.
//

import Foundation

enum DevBoardType: Int, Codable, Identifiable, CaseIterable {
    case bluetooth = 1
    case wifi = 2
    case usb = 3
    case unknown = 4
    
    var id: Int {
        return self.rawValue
    }
}

struct DevBoard: Codable, Identifiable {
    var id: UUID = UUID()
    var bluetoothName: String
    var cardId: UInt8
    var cardType: DevBoardType
    
    var displayName: String {
        return "Card: \(cardId) (\(cardType))"
    }
}
