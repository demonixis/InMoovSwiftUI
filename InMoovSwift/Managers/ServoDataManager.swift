//
//  ServoDataManager.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 29/04/2024.
//

import Foundation

class ServoDataManager: ObservableObject {
    static let shared = ServoDataManager()
    private static let userDefaultsKey = "servosData"
    
    @Published var servosData: [ServoData] {
        didSet {
            saveServosData()
        }
    }
    
    private init() {
        servosData = ServoDataManager.loadServosData()
    }
    
    func addServoData(inData: ServoData) {
        servosData.append(inData)
    }
    
    func removeServoData(offsets: IndexSet) {
        servosData.remove(atOffsets: offsets)
    }
    
    func saveServosData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(servosData) {
            UserDefaults.standard.set(encoded, forKey: ServoDataManager.userDefaultsKey)
        }
    }
    
    static func loadServosData() -> [ServoData] {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? decoder.decode([ServoData].self, from: data) {
            return decoded
        }
        return []
    }
}
