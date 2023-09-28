//
//  GuidePresenter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 22.09.2023.
//

import Foundation

protocol GuidePresenterProtocol {
    func fetchInfo()
    func tapGuideCell(with indexPath: IndexPath)
}

class GuidePresenter {
    private let info = JSONFiles.docs
    private weak var router: GuideRouter?
    
    weak var view: GuideViewControllerProtocol?
    
    init(router: GuideRouter) {
        self.router = router
        
        
    }
}

extension GuidePresenter: GuidePresenterProtocol {
    func fetchInfo() {
        var model: [GuideTypeCellModel] = []
        for (key, values) in info {
            if let values = values as? [[String: Any]] {
                model.append(.init(imageName: "", title: key, subtitle: "\(values.count) tips"))
            }
        }
        view?.dataSource.reloadData(section: .main(0), with: model, animated: true)
    }
    
    func tapGuideCell(with indexPath: IndexPath) {
        guard let view,
                let key = view.dataSource.items(in: .main(0))[safe: indexPath.row]?.title,
                let items = info[key] as? [[String: Any]] else {
            return
        }
        var model: [GuideDetailCellModel] = []
        for item in items {
            if let title = item["title"] as? String,
                let text = item["text"] as? String{
                model.append(.init(title: title, text: text))
            }
        }
        router?.openGuideDetail(with: model, title: key)
    }
}
