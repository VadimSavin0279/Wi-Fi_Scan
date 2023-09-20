//
//  ScreenRouter.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import UIKit

protocol ScreenRouter where Self: BaseScreenRouter {
    var routerIdentifiable: RouterIdentifiable { get }
    
    var screen: UIViewController { get }
    
    var presentationType: ScreenPresentationType { get }
}
