//
//  WifiManager.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 06/05/2024.
//

import Foundation

class WifiManager {
    static var serverIp = "http://192.168.1.1"
        
    static func sendData(_ message: String) {
        let urlString = "\(serverIp)?\(message)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[WifiManager] Error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("[WifiManager] Response: \(response.statusCode)")
            }
        }.resume()
    }
}
