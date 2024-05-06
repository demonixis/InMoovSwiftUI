//
//  DemoView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 28/04/2024.
//

import SwiftUI
import Network

struct DemoWifiServiceView: View {
    @State private var isConnectedToSpecificWifi = true
    @State private var headYawValue: Double = 0
    @State private var headPitchValue: Double = 0
    @State private var jawValue: Double = 0
    @State private var eyeXValue: Double = 0
    @State private var eyeYValue: Double = 0
    @State private var eyeOn = true
    @State private var demoMode = true
    
    var body: some View {
        List {
            Toggle("Demo Mode", isOn: $demoMode)
                .onChange(of: demoMode) {
                    sendData(command: .sysDemoMode, value: demoMode ? 1 : 0)
                }
            
            Text("Servo Controls")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                SliderRow(label: "Head Yaw", value: $headYawValue, asm: .headYaw, onValueChange: sendData)
                SliderRow(label: "Head Pitch", value: $headPitchValue, asm: .headPitch, onValueChange: sendData)
                SliderRow(label: "Jaw", value: $jawValue, asm: .jaw, onValueChange: sendData)
                SliderRow(label: "EyeX", value: $eyeXValue, asm: .eyeX, onValueChange: sendData)
                SliderRow(label: "EyeY", value: $eyeYValue, asm: .eyeY, onValueChange: sendData)
            }
            .disabled(demoMode)
            
            Text("Options")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle("Eye On/Off", isOn: $eyeOn)
                .disabled(demoMode)
                .onChange(of: eyeOn) {
                    let eyeState = eyeOn ? 1 : 0
                    sendData(command: .eyeLeft, value: eyeState)
                    sendData(command: .eyeRight, value: eyeState)
                }
            
            HStack {
                Button("Neutral") {
                    sendData(command: .allNeutral, value: 1);
                }
                
                Button("Random Audio") {
                    sendData(command: .animAudioRandom, value: 1);
                }
            }
            .disabled(demoMode)
            
            Text("Animations")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button("Blink Eye") {
                    sendData(command: .animEyeBlink, value: 1);
                }
                
                Button("Jaw") {
                    sendData(command: .animJawOpenClose, value: 1);
                }
                
                Button("Talk") {
                    sendData(command: .animJawTalk, value: 1);
                }
                
                Button("Head Yes") {
                    sendData(command: .animHeadYes, value: 1);
                }
                
                Button("Head No") {
                    sendData(command: .animHeadNo, value: 1);
                }
            }
            .disabled(demoMode)
        }
        .navigationTitle("Demonstration Mode")
        
    }
    
    func sendData(command: RobotCommand, value: Int) {
        let urlString = "http://192.168.1.1?\(command.rawValue)=\(value)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur de connexion : \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Réponse du serveur : \(response.statusCode)")
            }
        }.resume()
    }
}

struct SliderRow : View {
    var label: String
    @Binding var value: Double
    var asm: RobotCommand
    var onValueChange: (RobotCommand, Int) -> Void
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)
            Slider(value: $value, in: 0...180)
                .onChange(of: value) {
                    onValueChange(asm, Int(value))
                }
            Text("\(Int(value))°")
        }
    }
}

#Preview {
    DemoWifiServiceView()
}
