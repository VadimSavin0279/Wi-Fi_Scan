//
//  ScanMainPresenter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 26.09.2023.
//

import Foundation

protocol ScanMainPresenterProtocol {
    var serviceLAN: LANScanner { get }
    
    func startStopScan(value: Bool)
    func openResults()
}

class ScanMainPresenter {
    weak var view: ScanMainViewControllerProtocol?
    weak var router: ScanMainRouter?
    
    var devices: [LANDevice] = [] {
        didSet {
            view?.setTextDeviceFound("\(devices.count)")
        }
    }
    
    internal lazy var serviceLAN = LANScanner(delegate: self, continuous: false)
}

extension ScanMainPresenter: ScanMainPresenterProtocol {
    func startStopScan(value: Bool) {
        devices = []
        value ? serviceLAN.startScan() : serviceLAN.stopScan()
    }
}

extension ScanMainPresenter: LANScannerDelegate {
    func LANScannerDiscovery(_ device: LANDevice) {
        if device.ipAddress ~= "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}" {
            if !devices.contains(device: device) {
                devices.append(device)
            }
        }
    }
    func LANScannerFinished() {
        print("finish")
    }
    
    func openResults() {
        router?.openResult(devices: devices)
    }
}
