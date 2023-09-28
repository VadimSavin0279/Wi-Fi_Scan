//
//  ScanResultsPresenter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import UIKit

protocol ScanResultsPresenterProtocol {
    func getDelegate() -> DiffableTableViewDelegateProxy
    func configureModel()
}

class ScanResultsPresenter {
    weak var view: ScanResultsViewControllerProtocol?
    weak var router: ScanResultsRouterProtocol?
    
    private var delegate: Delegate?
    
    private let devices: [LANDevice]
    private var model: [DiffableTableSectionModel<CustomHeaderModel, ContentCellModel>] = [] {
        didSet {
            view?.dataSource.reloadData(model, animated: false)
            view?.dataSource.reloadSameData(animated: true)
        }
    }
    
    init(model: [LANDevice]) {
        devices = model
    }
}

extension ScanResultsPresenter: ScanResultsPresenterProtocol {
    func configureModel() {
        let localAdress = LANScanner.getLocalAddress()
        var trustedDevices: [ContentCellModel] = []
        var suspiciousDevices: [ContentCellModel] = []
        
        for device in devices {
            if device.ipAddress.components(separatedBy: ".").last == "1" {
                trustedDevices.append(.init(title: "Router", subtitle: device.ipAddress, image: nil))
            } else if device.ipAddress == localAdress?.ip {
                trustedDevices.append(.init(title: UIDevice.current.name, subtitle: device.ipAddress, image: nil))
            } else {
                suspiciousDevices.append(.init(title: "Unknown", subtitle: device.ipAddress, image: nil))
            }
        }
        
        let sectionTrusted = CustomHeaderModel(sectionIndex: 0, type: .trusted, rightText: "\(trustedDevices.count)")
        let sectionSuspicious = CustomHeaderModel(sectionIndex: 1, type: .suspecious, rightText: "\(suspiciousDevices.count)")
        
        let model = DiffableTableSectionModel(section: sectionTrusted, items: trustedDevices)
        let model1 = DiffableTableSectionModel(section: sectionSuspicious, items: suspiciousDevices)
        
        self.model = [model, model1]
    }
    
    func getDelegate() -> DiffableTableViewDelegateProxy {
        
        var sections: [CustomHeaderModel] = []
        
        for item in model {
            sections.append(item.section)
        }
        
        let result = Delegate(models: sections)
        result.identifierForHeaderInSection = { _ in "\(CustomHeader.self)" }
        result.heightForHeaderInSection = { _ in 32 }
        
        result.didSelectItem = didSelectItem(with:)
        
        delegate = result
        return result
    }
    
    func didSelectItem(with indexPath: IndexPath) {
        guard let section = view?.dataSource.sections[safe: indexPath.section] else { return }
        router?.openAllert(toSuspicious: section.type == .suspecious ? false : true) { [weak self] _ in
            self?.replaceDevice(from: indexPath)
        }
    }
    
    func replaceDevice(from indexPath: IndexPath) {
        guard let section = view?.dataSource.sections[safe: indexPath.section],
              let item = view?.dataSource.items(in: section)[safe: indexPath.row] else { return }
        
        var trustedDevices: [ContentCellModel] = []
        var suspiciousDevices: [ContentCellModel] = []
        
        for indexSection in 0..<(view?.dataSource.sections.count ?? 0) {
            if view?.dataSource.sections[indexSection].type == section.type {
                var items = view?.dataSource.items(in: section)
                items?.remove(at: indexPath.row)
                
                if section.type == .trusted {
                    trustedDevices = items ?? []
                } else {
                    suspiciousDevices = items ?? []
                }
            } else if let otherSection = view?.dataSource.sections[indexSection] {
                var items = view?.dataSource.items(in: otherSection)
                items?.append(item)
                
                if section.type == .suspecious {
                    trustedDevices = items ?? []
                } else {
                    suspiciousDevices = items ?? []
                }
            }
        }
        
        let sectionTrusted = CustomHeaderModel(sectionIndex: 0, type: .trusted, rightText: "\(trustedDevices.count)")
        let sectionSuspicious = CustomHeaderModel(sectionIndex: 1, type: .suspecious, rightText: "\(suspiciousDevices.count)")
        
        let model = DiffableTableSectionModel(section: sectionTrusted, items: trustedDevices)
        let model1 = DiffableTableSectionModel(section: sectionSuspicious, items: suspiciousDevices)
        
        delegate?.models = [sectionTrusted, sectionSuspicious]
        self.model = [model, model1]
    }
}
