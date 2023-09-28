//
//  Wi-FiService.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import Foundation
import Combine
import NetworkExtension

class ServiceWiFi {
    static let shared: ServiceWiFi = ServiceWiFi()
    
    private init() {}
    
    func getWifiInfo() {
        NEHotspotNetwork.fetchCurrent { network in
            print(network)
        }
    }
    
}
