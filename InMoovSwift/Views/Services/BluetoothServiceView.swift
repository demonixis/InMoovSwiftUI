//
//  BluetoothServiceView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 03/05/2024.
//

import Foundation
import SwiftUI

struct BluetoothServiceView: View {
    @ObservedObject private var settingsManager = SettingsManager.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(settingsManager.devBoardData, id: \.id) { currentBoard in
                    NavigationLink(destination: ConnectionItem(data: $settingsManager.devBoardData[settingsManager.devBoardData.firstIndex(where: { $0.id == currentBoard.id })!])) {
                        Text("\(currentBoard.displayName)")
                    }
                }
                .onDelete(perform: deleteConnectionItem)
                
                Button(action: addConnectionItem) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                        Text("Add Card")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Bluetooth")
            //.navigationBarItems(trailing: Button("Save") {
            //    settingsManager.saveCardData()
            //})
        }
    }
    
    private func addConnectionItem() {
        let dev = DevBoardData(bluetoothName: BluetoothManager.targetDeviceName, cardId: 0, cardType: .bluetooth)
        settingsManager.devBoardData.append(dev)
    }
    
    private func deleteConnectionItem(at offsets: IndexSet) {
        settingsManager.devBoardData.remove(atOffsets: offsets)
    }
}

struct ConnectionItem: View {
    @ObservedObject private var bluetooth: BluetoothManager = BluetoothManager.shared;
    @Binding var data:DevBoardData

    private let cardIds = Array(0...10).map { $0 }
    
    var body: some View {
        Form {
            List {
                HStack {
                    Picker("Card ID", selection: $data.cardId) {
                        ForEach(cardIds, id: \.self) { cardId in
                            Text("\(cardId)").tag(UInt8(cardId))
                        }
                    }
                }
                
                HStack {
                    Picker("Card Type", selection: $data.cardType) {
                        ForEach(DevBoardType.allCases, id: \.self) { cardType in
                            Text("\(cardType)").tag(cardType)
                        }
                    }
                }
                
                HStack {
                    TextField("Bluetooth name", text: $data.bluetoothName)
                }
                .disabled(data.cardType != .bluetooth)
                
                HStack {
                    Text("Bluetooth \(bluetooth.getStringStatus())")
                    Spacer()
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(bluetooth.getColorStatus())
                }
                .disabled(data.cardType != .bluetooth)
                
                HStack {
                    Spacer()
                    Button("\(bluetooth.isConnected ? "Disconnect" : "Connect")") {
                        if (bluetooth.isConnected) {
                            deconnectDevice()
                        } else {
                            connectDevice()
                        }
                    }
                }
                .disabled(data.cardType != .bluetooth)
            }
        }
    }
    
    func connectDevice() {
        
    }
    
    func deconnectDevice() {
        
    }
}

#Preview {
    BluetoothServiceView()
}
