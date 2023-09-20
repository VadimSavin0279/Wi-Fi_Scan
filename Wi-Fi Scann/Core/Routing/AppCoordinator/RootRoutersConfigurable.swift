//
//  RootRoutersConfigurable.swift
//  FaxApp
//
//  Created by Eugene on 16.05.2022.
//

import UIKit

protocol RootRoutersConfigurable: AnyObject {
    func configure(routers: [ScreenRouter])
}
