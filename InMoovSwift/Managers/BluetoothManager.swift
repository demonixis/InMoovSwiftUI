//
//  BluetoothManager.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 24/04/2024.
//
import CoreBluetooth
import Foundation
import SwiftUI

enum BluetoothStatus: String {
    case disconnected = "Disconnected"
    case connected = "Connected"
    case scanning = "Scanning"
}

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static var shared = BluetoothManager()
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    static let targetDeviceName = "InMoovSharpBT-LE"
    static let targetServiceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    static let targetCharacteristicUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    @Published var isConnected = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
    }
    
    func getColorStatus() -> Color {
        if isConnected {
            return .green
        } else if centralManager.isScanning {
            return .orange
        }
        
        return .red
    }
    
    func getStringStatus() -> BluetoothStatus {
        if isConnected {
            return .connected
        } else if centralManager.isScanning {
            return .scanning
        }
        
        return .disconnected
    }
    
    func isScaning() -> Bool {
        return centralManager.isScanning
    }
    
    func connect() {
        guard centralManager.state == .poweredOn else {
            logMessage("Bluetooth is not powered on")
            return
        }
        
        if !isConnected {
            if centralManager.isScanning {
                logMessage("Bluetooth Manager already scanning")
                return
            }
            
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            logMessage("Bluetooth Manager already connected")
        }
    }
    
    func stopScan() {
        guard centralManager.isScanning else {
            logMessage("Already scaning")
            return
        }
        
        centralManager.stopScan()
    }
    
    func sendData(_ message: String) {
        if let data = message.data(using: .utf8) {
            sendData(data)
        } else {
            logMessage("Failed to convert \(message) to Data")
        }
    }
    
    func sendData(_ data: Data) {
        guard let peripheral = self.peripheral, let services = peripheral.services else {
            logMessage("Peripheral not connected or services not discovered")
            return
        }

        if let service = services.first(where: { $0.uuid == BluetoothManager.targetServiceUUID }),
           let characteristic = service.characteristics?.first(where: { $0.uuid == BluetoothManager.targetCharacteristicUUID }) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    func disconnect() {
        if let peripheral = self.peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth is not available.")
            isConnected = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        logMessage("Found Bluetooth Device: \(peripheral.name ?? "NoBTName")")
        
        if peripheral.name == BluetoothManager.targetDeviceName {
            logMessage("Found targeted device! \(BluetoothManager.targetDeviceName)")
            self.peripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isConnected = true
        logMessage("Connected to \(peripheral.name ?? "device")")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        logMessage("Disconnected from \(peripheral.name ?? "device")")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            logMessage(err.localizedDescription)
            return
        }
        
        guard let services = peripheral.services else {
            logMessage("No services discovered")
            return
        }
        
        for service in services {
            if service.uuid == BluetoothManager.targetServiceUUID {
                logMessage("Discovering characteristics")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    private func logMessage(_ message: String) {
        print("[BluetoothManager] \(message)")
    }
}
