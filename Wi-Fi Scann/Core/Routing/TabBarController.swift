//
//  TabBarController.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import UIKit
import Combine

final class TabBarController: UITabBarController {
    private(set) var currentTab: TabBarType = .scanner
    
    var onItemTap: IClosure<TabBarType>?
    
    private let tabBarTopBorder = UIView()
    private let tabBarBackgroundArea = UIView()
    private let tabBarMenu: TabBarMenu
    
    init(items: [TabBarType]) {
        self.tabBarMenu = TabBarMenu(items: items)
        super.init(nibName: nil, bundle: nil)
        self.tabBar.isHidden = true
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewControllers?.forEach { controller in
            controller.additionalSafeAreaInsets =  UIEdgeInsets(
                top: tabBar.safeAreaInsets.top,
                left: tabBar.safeAreaInsets.left,
                bottom: .layout.tabHeight,
                right: tabBar.safeAreaInsets.right
            )
        }
    }
    
    func switchToTab(tab: TabBarType) {
        tabBarMenu.setSelected(item: tab)
        self.selectedIndex = tab.rawValue
        self.currentTab = tab
    }
    
    // MARK: - Private
    
    private func configureSelf() {
        view.addSubview(tabBarTopBorder)
        view.addSubview(tabBarBackgroundArea)
        view.addSubview(tabBarMenu)
        apply()
        
        tabBarMenu.onItemTap = { [weak self] item in
            guard let self = self else { return }
            self.selectedIndex = item.rawValue
            self.currentTab = item
            self.onItemTap?(item)
        }
        
        configureConstraints()
        
    }
    
    private func configureConstraints() {
        tabBarTopBorder.pinEdges(toSuperviewEdges: [.left, .right])
        tabBarTopBorder.pinEdge(.top, to: .top, of: tabBarMenu, withOffset: -1)
        tabBarTopBorder.setDimension(.height, toSize: 1)
        
        tabBarBackgroundArea.pinEdge(.top, to: .top, of: tabBarMenu)
        tabBarBackgroundArea.pinEdges(toSuperviewEdges: [.left, .right, .bottom])
        
        tabBarMenu.pinEdges(toSuperviewEdges: [.left, .right])
        tabBarMenu.pin(toBottomLayoutGuideOf: self, withInset: 8)
        tabBarMenu.setDimension(.height, toSize: .layout.tabHeight - 1)
    }
}

extension TabBarController {
    func apply() {
        self.tabBarBackgroundArea.backgroundColor = .white.withAlphaComponent(1)
        self.tabBarTopBorder.backgroundColor = .black.withAlphaComponent(0.15)
    }
}
