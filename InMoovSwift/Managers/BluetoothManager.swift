//
//  BluetoothManager.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 24/04/2024.
//
import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    let targetDeviceName = "InMoovSharpBT-LE"
    let targetServiceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let targetCharacteristicUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    // États de connexion pour l'interface utilisateur
    @Published var isConnected = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func connect() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        if !isConnected {
            centralManager.scanForPeripherals(withServices: [targetServiceUUID], options: nil)
        }
    }
    
    func sendData(data: Data) {
        guard let peripheral = self.peripheral, let services = peripheral.services else {
            print("Peripheral not connected or services not discovered")
            return
        }

        if let service = services.first(where: { $0.uuid == targetServiceUUID }),
           let characteristic = service.characteristics?.first(where: { $0.uuid == targetCharacteristicUUID }) {
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
        if peripheral.name == targetDeviceName {
            self.peripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isConnected = true
        print("Connected to \(peripheral.name ?? "device")")
        peripheral.discoverServices([targetServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        print("Disconnected from \(peripheral.name ?? "device")")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == targetServiceUUID {
                peripheral.discoverCharacteristics([targetCharacteristicUUID], for: service)
            }
        }
    }
}
