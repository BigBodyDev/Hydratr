//
//  BluetoothManager.swift
//  Hydratr
//
//  Created by Devin Green on 4/17/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

enum Proximity: Int{
    case immediate = 0
    case near = 1
    case far = 2
    case poweredOff = 3
    case unauthorized = 4
    case unsupported = 5
    case resetting = 6
    case unknown = 7
}

class BluetoothViewer: ObservableObject {
    static let shared = BluetoothViewer()
    @Published var hydratrProximity: Proximity = .unknown
    private let manager = BluetoothManager()

    init() {
        manager.startBluetoothManager()
    }
    
    func changeProximity(proximity: Proximity){
        hydratrProximity = proximity
    }
}

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager! = nil
    
    override init() {
        super.init()
    }
    
    func startBluetoothManager(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }
    
    private func scan(){
        self.centralManager.scanForPeripherals(withServices: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            BluetoothViewer.shared.changeProximity(proximity: .unknown)
        case .resetting:
            BluetoothViewer.shared.changeProximity(proximity: .resetting)
        case .unsupported:
            BluetoothViewer.shared.changeProximity(proximity: .unsupported)
        case .unauthorized:
            BluetoothViewer.shared.changeProximity(proximity: .unauthorized)
        case .poweredOff:
            BluetoothViewer.shared.changeProximity(proximity: .poweredOff)
        case .poweredOn:
            self.scan()
        @unknown default:
            BluetoothViewer.shared.changeProximity(proximity: .unknown)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier.uuidString == "4C238FBF-7566-FF05-357F-F4759025E5A5"{
            if Int(truncating: RSSI) > -25{
                BluetoothViewer.shared.changeProximity(proximity: .immediate)
            }else if Int(truncating: RSSI) > -65{
                BluetoothViewer.shared.changeProximity(proximity: .near)
            }else {
                BluetoothViewer.shared.changeProximity(proximity: .far)
            }
            central.stopScan()
            self.scan()
        }
    }
    
}
