//
//  ServoMixerManager.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 06/05/2024.
//

import Foundation

///
/// API:
/// - Command=Value
/// - Command=Value1:Value2:Value3:Value4
///
class ServoMixer {
    static let shared = ServoMixer()
    let bluetooth = BluetoothManager.shared
    
    init() {
        // Singleton init
    }
    
    func sendDataToCard(value: String, cardId: UInt8) {
        print("Send data to card: \(cardId) with Value: \(value)")
        
        guard let card = getCard(cardId) else {
            print("[ServoMixerManager] Card \(cardId) wasn't found")
            return
        }
        
        if card.cardType == .bluetooth {
            bluetooth.sendData(value)
        } else if card.cardType == .wifi {
            WifiManager.sendData(value)
        } else {
            print("[ServoMixerManager] \(card.cardType) is not yet supported")
        }
    }
    
    func getCard(_ id: UInt8) -> DevBoardData? {
        let allBoards = SettingsManager.shared.devBoardData
        
        for board in allBoards {
            if board.cardId == id {
                return board
            }
        }
        
        return nil
    }
    
    ///
    /// API: Command=PinID:PreviousPin
    ///
    func updateServoConfig(data: ServoData, previousPin: UInt8) {
        let cardId = data.cardId
        let pinId = data.pinId
        let valueStr = "\(RobotCommand.updateServoConfig.rawValue)=\(pinId):\(previousPin)"
        sendDataToCard(value: valueStr, cardId: cardId)
    }
    
    ///
    /// API: Command=PinID
    ///
    func removeServoConfig(_ data: ServoData) {
        let cardId = data.cardId
        let pinId = data.pinId
        let valueStr = "\(RobotCommand.removeServoConfig.rawValue)=\(pinId)"
        sendDataToCard(value: valueStr, cardId: cardId)
    }
    
    ///
    /// API: Command=PinID:1|0
    ///
    func setServoEnabled(_ data: ServoData) {
        let cardId = data.cardId
        let pinId = data.pinId
        let valueStr = "\(RobotCommand.setServoEnabled.rawValue)=\(pinId):\(data.enabled ? 1 : 0)"
        sendDataToCard(value: valueStr, cardId: cardId)
    }
    
    ///
    /// API: Command=PinID:ServoValue
    ///
    func sendServoValue(_ data: ServoData) {
        let cardId = data.cardId
        let pinId = data.pinId
        var value = clampServoValue(inMin: data.min, inMax: data.max, inValue: data.value)
        
        if data.invert {
            value = invertServoValue(inValue: value)
        }
        
        if data.enabled && data.mixage != .None {
            // TODO
        }
        
        let valueStr = "\(RobotCommand.setServoValue.rawValue)=\(pinId):\(value)"
        sendDataToCard(value: valueStr, cardId: cardId)
    }
        
    func clampServoValue(inMin: UInt8, inMax: UInt8, inValue: UInt8) -> UInt8 {
        var value = inValue
        value = max(inMin, value)
        value = min(inMax, value)
        return value
    }
    
    func invertServoValue(inValue: UInt8) -> UInt8 {
        return 180 - inValue
    }
}
