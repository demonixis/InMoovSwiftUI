//
//  BluetoothServiceView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 03/05/2024.
//

import Foundation
import SwiftUI

struct BluetoothServiceView: View {
    @State private var boards: [DevelopmentBoard] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(boards, id: \.id) { currentBoard in
                    NavigationLink(destination: ConnectionItem(data: boards[boards.firstIndex(where: { $0.id == currentBoard.id })!])) {
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
            .navigationBarItems(trailing: Button("Save") {
                
            })
        }
    }
    
    private func addConnectionItem() {
        let dev = DevelopmentBoard(bluetoothName: BluetoothManager.targetDeviceName, cardId: 0)
        boards.append(dev)
    }
    
    private func deleteConnectionItem(at offsets: IndexSet) {
        boards.remove(atOffsets: offsets)
    }
}

struct ConnectionItem: View {
    @ObservedObject private var bluetoothManager: BluetoothManager = BluetoothManager.shared;
    @State var data:DevelopmentBoard
    
    private let cardIds = Array(0...10).map { $0 }
    
    var body: some View {
        Form {
            
            Text("Bluetooth \(bluetoothManager.isConnected ? "Connected" : "Disconnected")")
            
            Spacer()
            
            Button("\(bluetoothManager.isConnected ? "Disconnect" : "Connect")") {
                if (bluetoothManager.isConnected) {
                    deconnectDevice()
                } else {
                    connectDevice()
                }
            }
            
            Spacer()
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(bluetoothManager.isConnected ? .green : .red)
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
