//
//  Magnetometer.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 22.09.2023.
//

import Foundation
import CoreLocation
import Combine

class Magnetometer: NSObject {
    static let shared: Magnetometer = {
        let result = Magnetometer()
        result.manageLocation.delegate = result
        result.manageLocation.headingFilter = 1
        return result
    }()
    
    private let manageLocation = CLLocationManager()
    
    @Published var magneticStrenght: Int = 0
    
    private override init() {}
    
    func start() {
        if (CLLocationManager.headingAvailable()) {
            manageLocation.startUpdatingHeading()
        }
    }
    
    func stop() {
        manageLocation.stopUpdatingHeading()
    }
    
    private func calculateStrenghtMagneticField(_x: Double,
                                                _y: Double,
                                                _z: Double) {
        let valueDouble = sqrt(pow(_x, 2) + pow(_y, 2) + pow(_z, 2))
        magneticStrenght = Int(valueDouble)
    }
}

extension Magnetometer: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        calculateStrenghtMagneticField(_x: newHeading.x,
                                       _y: newHeading.y,
                                       _z: newHeading.z)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
