import UIKit
import SwiftyPing
// MARK: - Model

class LANDevice: NSObject {
    
    var ipAddress = ""
    var hostName = ""
}

// MARK: - Protocol

@objc protocol LANScannerDelegate {
    /**
     Triggered when the scanning has discovered a new device
     */
    @objc optional func LANScannerDiscovery(_ device: LANDevice)
    
    /**
     Triggered when all of the scanning has finished
     */
    @objc optional func LANScannerFinished()
    
    /**
     Triggered when the scanner starts over
     */
    @objc optional func LANScannerRestarted()
    
    /**
     Triggered when there is an error while scanning
     */
    @objc optional func LANScannerFailed(_ error: NSError)
}

// MARK: - Lan Scanner

class LANScanner: NSObject {
    
    struct NetInfo {
        let ip: String
        let netmask: String
    }
    
    var delegate: LANScannerDelegate?
    var continuous: Bool = true
    
    var localAddress: String?
    var baseAddress: String?
    var currentHostAddress: Int = 0
    var timer: Timer?
    var netMask: String?
    var baseAddressEnd: Int = 0
    var timerIterationNumber: Int = 0
    
    override init() {
        super.init()
    }
    
    init(delegate: LANScannerDelegate, continuous: Bool) {
        super.init()
        self.delegate = delegate
        self.continuous = continuous
    }
    
    // MARK: - Actions
    
    func startScan() {
        if let localAddress = LANScanner.getLocalAddress() {
            self.localAddress = localAddress.ip
            self.netMask = localAddress.netmask
            
            let netMaskComponents = addressParts(self.netMask!)
            let ipComponents = addressParts(self.localAddress!)
            
            if netMaskComponents.count == 4 && ipComponents.count == 4 {
                
                for _ in 0 ..< 4 {
                    
                    self.baseAddress = "\(ipComponents[0]).\(ipComponents[1]).\(ipComponents[2])."
                    self.currentHostAddress = 0
                    self.timerIterationNumber = 0
                    self.baseAddressEnd = 255
                }
                
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LANScanner.pingAddress), userInfo: nil, repeats: true)
            }
        } else {
            self.delegate?.LANScannerFailed?(NSError(
                domain: "LANScanner",
                code: 101,
                userInfo: [ "error": "Unable to find a local address" ]
                )
            )
        }
    }
    
    func stopScan() {
        self.timer?.invalidate()
    }
    
    
    // MARK: - Ping Helpers
    
    @objc func pingAddress() {
        self.currentHostAddress += 1
        let address: String = "\(self.baseAddress!)\(self.currentHostAddress)"
        let once = try? SwiftyPing(host: address, configuration: PingConfiguration(interval: 0.1, with: 1), queue: DispatchQueue.global())
        once?.observer = { (response) in
            let pingError = response.error
            print("\nError for \(address) is \(String(describing: pingError))")
            if (pingError == nil) {
                once!.stopPinging()
                self.pingResult(success: true, ipAdress: response.ipAddress ?? "\(self.baseAddress!)\(self.currentHostAddress)")
                return
            } else {
                self.pingResult(success: false)
                once!.stopPinging()
                return
            }
        }
        once?.targetCount = 1
        try? once?.startPinging()
        if self.currentHostAddress >= 254 && !continuous {
            self.timer?.invalidate()
        }
    }
    
    @objc func pingResult(success: Bool, ipAdress: String = "") {
        self.timerIterationNumber += 1
        
        if success {
            /// Send device to delegate
            let device = LANDevice()
            device.ipAddress = ipAdress
            if let hostName = LANScanner.getHostName(device.ipAddress) {
                device.hostName = hostName
            }
            self.delegate?.LANScannerDiscovery?(device)
        } else {
            let device = LANDevice()
            device.ipAddress = "Error"
            device.hostName = "Error"
            self.delegate?.LANScannerDiscovery?(device)
        }
        
        /// When you reach the end, either restart or call it quits
        if self.timerIterationNumber >= 254 {
            if continuous {
                self.timerIterationNumber = 0
                self.currentHostAddress = 0
                self.delegate?.LANScannerRestarted?()
            } else {
                self.delegate?.LANScannerFinished?()
            }
        }
    }
    
    
    // MARK: - Network methods
    
    static func getHostName(_ ipaddress: String) -> String? {
        var hostName: String? = nil
        var ifinfo: UnsafeMutablePointer<addrinfo>?
        
        /// Get info of the passed IP address
        if getaddrinfo(ipaddress, nil, nil, &ifinfo) == 0 {
            
            var ptr = ifinfo
            while ptr != nil {
                
                let interface = ptr!.pointee
                
                /// Parse the hostname for addresses
                var hst = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(interface.ai_addr, socklen_t(interface.ai_addrlen), &hst, socklen_t(hst.count),
                               nil, socklen_t(0), 0) == 0 {
                    
                    if let address = String(validatingUTF8: hst) {
                        hostName = address
                    }
                }
                ptr = interface.ai_next
            }
            freeaddrinfo(ifinfo)
        }
        
        return hostName
    }
    
    static func getLocalAddress() -> NetInfo? {
        var localAddress:NetInfo?
        
        /// Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            /// For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                
                let interface = ptr!.pointee
                let flags = Int32(interface.ifa_flags)
                var addr = interface.ifa_addr.pointee
                
                /// Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        /// Narrow it down to the interfaces matching Standard Ethernet
                        let name = String(cString:interface.ifa_name)
                        if name.range(of:"en") != nil {
                            
                            /// Convert interface address to a human readable string
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8: hostname) {
                                    
                                    var net = interface.ifa_netmask.pointee
                                    var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                    
                                    if getnameinfo(&net, socklen_t(net.sa_len), &netmaskName, socklen_t(netmaskName.count),
                                                   nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                                        if let netmask = String(validatingUTF8: netmaskName) {
                                            localAddress = NetInfo(ip: address, netmask: netmask)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                ptr = interface.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return localAddress
    }
    
    func addressParts(_ address: String) -> [String] {
        return address.components(separatedBy: ".")
    }
}
