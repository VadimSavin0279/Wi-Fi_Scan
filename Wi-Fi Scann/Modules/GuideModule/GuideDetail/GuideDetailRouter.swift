//
//  GuideDetailRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 22.09.2023.
//

import UIKit

final class GuideDetailRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.guideDescription
    let presentationType: ScreenPresentationType = .plain
    
    private let model: [GuideDetailCellModel]
    private let title: String
    
    init(model: [GuideDetailCellModel], title: String) {
        self.model = model
        self.title = title
    }
    
    private lazy var _screen: UIViewController = {
        let view = GuideDetailViewController(model: model, title: title)
        return view
    }()
}
