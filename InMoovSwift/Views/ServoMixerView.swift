//
//  ServoMixerView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 28/04/2024.
//

import SwiftUI
import Network

struct ServoMixerView: View {
    @State private var servosData: [ServoData] = ServoDataManager.shared.servosData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(servosData, id: \.id) { servoData in
                    NavigationLink(destination: ServoDataView(servoData: $servosData[servosData.firstIndex(where: { $0.id == servoData.id })!])) {
                        Text("\(servoData.servo.displayName)")
                    }
                }
                .onDelete(perform: delete)
                
                Button(action: addServo) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                        Text("Add New Servo")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Servos")
            .navigationBarItems(trailing: Button("Save") {
                saveSettings()
            })
        }
    }
    
    private func addServo() {
        let newServoData = ServoData(servo: .headYaw)
        servosData.append(newServoData)
        //dataManager.addServoData(inData: newServoData)
    }
    
    private func delete(at offsets: IndexSet) {
        servosData.remove(atOffsets: offsets)
        //dataManager.removeServoData(offsets: offsets)
    }
    
    private func saveSettings() {
        let manager = ServoDataManager.shared
        manager.servosData = servosData
        manager.saveServosData()
    }
}

struct ServoDataView: View {
    @Binding var servoData: ServoData
    let allServos = RobotServo.allCases
    let allMixageTypes = ServoMixageType.allCases
    let pinIds = Array(2...64).map { $0 }
    let cardIds = Array(0...10).map { $0 }
    
    var body: some View {
        Form {
            Picker("Servo", selection: $servoData.servo) {
                ForEach(allServos, id: \.self) { servo in
                    Text(servo.displayName).tag(servo as RobotServo?)
                }
            }
            
            Picker("Pin ID", selection: $servoData.pinId) {
                ForEach(pinIds, id: \.self) { pinId in
                    Text("\(pinId)").tag(UInt8(pinId))
                }
            }
            
            Picker("Card ID", selection: $servoData.cardId) {
                ForEach(cardIds, id: \.self) { cardId in
                    Text("\(cardId)").tag(UInt8(cardId))
                }
            }
            
            Toggle("Enabled", isOn: $servoData.enabled)
            Toggle("Invert", isOn: $servoData.invert)
            Toggle("Scale Value to 180", isOn: $servoData.scaleValueTo180)
            
            VStack(alignment: .leading) {
                Text("Min: \(servoData.min)")
                Slider(value: Binding(
                    get: { Double(servoData.min) },
                    set: { servoData.min = UInt8($0) }
                ), in: 0...180)
            }
            
            VStack(alignment: .leading) {
                Text("Max: \(servoData.max)")
                Slider(value: Binding(
                    get: { Double(servoData.max) },
                    set: { servoData.max = UInt8($0) }
                ), in: 0...180)
            }
            
            VStack(alignment: .leading) {
                Text("Neutral: \(servoData.neutral)")
                Slider(value: Binding(
                    get: { Double(servoData.neutral) },
                    set: { servoData.neutral = UInt8($0) }
                ), in: 0...180)
            }
            
            VStack(alignment: .leading) {
                Text("Sleep Delay (s): \(servoData.sleepDelay)")
                Slider(value: Binding(
                    get: { Double(servoData.sleepDelay) },
                    set: { servoData.sleepDelay = UInt8($0) }
                ), in: 0...10)
            }
            
            Picker("Mixed Servo", selection: $servoData.mixedServo) {
                Text("None").tag(RobotServo?.none)
                ForEach(allServos, id: \.self) { servo in
                    Text(servo.displayName).tag(servo as RobotServo?)
                }
            }
            
            Picker("Mixage Type", selection: $servoData.mixage) {
                Text("None").tag(ServoMixageType?.none)
                ForEach(allMixageTypes, id: \.self) { type in
                    Text("\(type)").tag(type as ServoMixageType?)
                }
            }
        }
        .navigationBarTitle("Edit Servo")
    }
}

#Preview {
    ServoMixerView()
}
