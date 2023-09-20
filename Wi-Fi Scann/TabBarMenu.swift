//
//  TabBarMenu.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import UIKit

final class TabBarMenu: UIView {
    
    // MARK: - Internal properties
    
    var onItemTap: IClosure<TabBarType>?
    
    // MARK: - Private properties
    
    private let items: [TabBarType]
    private let container = UIView()
    private var buttons: [TrunButton] = []
    
    private var selectedItem: TabBarType
    
    // MARK: - Init
    
    init(
        items: [TabBarType]
    ) {
        self.items = items
        selectedItem = items[0]
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func setSelected(item: TabBarType) {
        toggleSeleted(to: item)
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        configureTabsStackView()
    }
    
    private func configureTabsStackView() {
        addSubview(container)
        container.pinEdgesToSuperviewEdges()
        
        var previousView: UIView = container
        
        buttons = items.enumerated().map { idx, item in
            let iconModel = TrunButton.IconModel(
                position: .top,
                offset: 7,
                sizelayout: .empty,
                image: item.selectedImage,
                inactiveImage: item.unselectedImage,
                tintColor: Asset.Colors.mainBlue.color,
                tintInactiveColor: Asset.Colors.gray99.color
            )
            let btn = TrunButton(title: item.title,
                                 titleColor: Asset.Colors.mainBlue.color,
                                 backroundColor: nil,
                                 borderColor: nil,
                                 titleInactiveColor: Asset.Colors.gray99.color,
                                 font: .systemFont(ofSize: 10),
                                 iconModel: iconModel,
                                 height: 45)
            btn.borderRadius = 0
            btn.bordersWidth = 0
            btn.onTap = { [weak self] in
                self?.handleTap(item: item)
            }
            
            container.addSubview(btn)
            btn.match(.width, to: .width, of: container, withMultiplier: 0.2)
            if idx == 0 {
                btn.pinEdge(.left, to: .left, of: previousView)
            } else {
                btn.pinEdge(.left, to: .right, of: previousView)
            }
            btn.pinEdge(toSuperviewEdge: .top, withInset: 5)
            
            previousView = btn
            
            return btn
        }
        toggleSeleted(to: selectedItem)
    }
    
    private func handleTap(item: TabBarType) {
        guard item != selectedItem else {
            return
        }
        
        toggleSeleted(to: item)
        onItemTap?(item)
    }
    
    private func toggleSeleted(to item: TabBarType) {
        buttons.enumerated().forEach { idx, btn in
            if items[idx] == item {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        selectedItem = item
    }
}


extension TabBarType {
    var title: String {
        switch self {
        case .scanner:
            return L10n.TabBar.scanner
        case .scanHistory:
            return L10n.TabBar.history
        case .guide:
            return L10n.TabBar.guide
        case .magnetic:
            return L10n.TabBar.magnetic
        case .settings:
            return L10n.TabBar.settings
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .scanner:
            return Asset.Assets.scannerIcon.image
        case .scanHistory:
            return Asset.Assets.historyIcon.image
        case .guide:
            return Asset.Assets.guideIcon.image
        case .magnetic:
            return Asset.Assets.magneticIcon.image
        case .settings:
            return Asset.Assets.settingsIcon.image
        }
    }
    
    var unselectedImage: UIImage {
        switch self {
        case .scanner:
            return Asset.Assets.scannerIcon.image
        case .scanHistory:
            return Asset.Assets.historyIcon.image
        case .guide:
            return Asset.Assets.guideIcon.image
        case .magnetic:
            return Asset.Assets.magneticIcon.image
        case .settings:
            return Asset.Assets.settingsIcon.image
        }
    }
}

