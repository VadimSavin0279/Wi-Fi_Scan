//
//  TrunButton.swift
//  FaxApp
//
//  Created by Eugene on 13.04.2022.
//

import UIKit

final class TrunButton: UIView {
    
    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleInactive: String
    
    var onTap: VoidClosure? {
        didSet {
            onTapChanged()
        }
    }
    
    var borderRadius: CGFloat = 8 {
        didSet { updateBordersShape() }
    }
    
    var bordersWidth: CGFloat = 1 {
        didSet { updateBordersShape() }
    }
    
    var isActive: Bool = true {
        didSet {
            apply()
        }
    }
    
    var isSelected: Bool = true {
        didSet {
            self.apply()
        }
    }
    
    var titleColor: UIColor {
        didSet {
            apply()
        }
    }
    
    var backroundThemedColor: UIColor? {
        didSet { apply() }
    }
    
    private let container = UIView()
    private let titleLabel = UILabel()
    
    private let contentXAlignment: LXAlignment
    private let contentYAlignment: LYAlignment
    private let titleInactiveColor: UIColor?
    private let backroundInactiveThemedColor: UIColor?
    private let borderColor: UIColor?
    private let borderInactiveColor: UIColor?
    private let iconModel: IconModel?
    private let iconImageView: UIImageView?
    private let height: CGFloat
    
    init(
        title: String,
        titleColor: UIColor = .blue,
        backroundColor: UIColor? = Asset.Colors.mainBlue.color,
        borderColor: UIColor? = .clear,
        titleInactive: String? = nil,
        titleInactiveColor: UIColor? = nil,
        backroundInactiveThemedColor: UIColor? = nil,
        borderInactiveColor: UIColor? = nil,
        font: UIFont = .systemFont(ofSize: 14, weight: .semibold),
        iconModel: IconModel? = nil,
        contentXAlignment: LXAlignment = .center(offset: 0),
        contentYAlignment: LYAlignment = .center(offset: 0),
        height: CGFloat = 48
    ) {
        self.title = title
        self.contentXAlignment = contentXAlignment
        self.contentYAlignment = contentYAlignment
        self.titleColor = titleColor
        self.titleInactive = titleInactive ?? title
        self.titleInactiveColor = titleInactiveColor
        self.backroundThemedColor = backroundColor
        self.backroundInactiveThemedColor = backroundInactiveThemedColor
        self.borderColor = borderColor
        self.borderInactiveColor = borderInactiveColor
        self.iconModel = iconModel
        iconImageView = iconModel?.image == nil ? nil : UIImageView()
        self.height = height
        super.init(frame: .zero)
        self.titleLabel.font = font
        titleLabel.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        addSubview(container)
        container.addSubview(titleLabel)
        if let iconImageView = iconImageView {
            container.addSubview(iconImageView)
        }
        
        updateBordersShape()
        configureConstraints()
        
    }
    
    private func configureConstraints() {
        setDimension(.height, toSize: height)
        
        configureContentContainerConstrains()
        configureContentConstraints()
    }
    
    private func configureContentContainerConstrains() {
        container.alignView(y: contentYAlignment)
        container.alignView(x: contentXAlignment)
    }
    
    private func configureContentConstraints() {
        guard let iconModel = iconModel, let iconView = iconImageView else {
            titleLabel.centerInSuperview()
            container.pinEdge(.top, to: .top, of: titleLabel)
            container.pinEdge(.bottom, to: .bottom, of: titleLabel)
            container.pinEdges(toSuperviewEdges: [.left, .right])
            return
        }
        
        let offset = iconModel.offset
        
        switch iconModel.position {
        case .left:
            container.centerInSuperview()
            
            iconView.alignAxis(toSuperviewAxis: .y)
            iconView.pinEdge(toSuperviewEdge: .left)
            
            titleLabel.alignAxis(toSuperviewAxis: .y)
            titleLabel.pinEdge(.left, to: .right, of: iconView, withOffset: offset)
            titleLabel.pinEdge(toSuperviewEdge: .right)
            
        case .right:
            container.centerInSuperview()
            
            titleLabel.pinEdge(toSuperviewEdge: .left)
            titleLabel.alignAxis(toSuperviewAxis: .y)
            
            iconView.alignAxis(toSuperviewAxis: .y)
            iconView.pinEdge(.left, to: .right, of: iconView, withOffset: offset)
            iconView.pinEdge(toSuperviewEdge: .right)
            
        case .top:
            container.alignAxis(toSuperviewAxis: .x)
            container.pinEdge(.top, to: .top, of: iconView)
            container.pinEdge(.bottom, to: .bottom, of: titleLabel)
            
            iconView.alignAxis(toSuperviewAxis: .x)
            iconView.pinEdge(toSuperviewEdge: .top)
            
            titleLabel.alignAxis(toSuperviewAxis: .x)
            titleLabel.pinEdge(.top, to: .bottom, of: iconView, withOffset: offset)
            container.pinEdges(toSuperviewEdges: [.left, .right])
        }
        
        switch iconModel.sizelayout {
        case .empty:
            break
        case let .fixed(size):
            iconView.setDimensions(to: size)
        case let .scaled(x, y):
            iconView.match(.height, to: .height, of: container, withMultiplier: y)
            iconView.match(.width, to: .width, of: container, withMultiplier: x)
        }
        
        if let contentMode = iconModel.contentMode {
            iconView.contentMode = contentMode
        }
    }
    
    private func onTapChanged() {
        if onTap == nil {
            self.gestureRecognizers?.removeAll()
        } else {
            self.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(handleTap))
            )
        }
    }
    
    private func updateBordersShape() {
        applyBordersShape(width: bordersWidth, radius: borderRadius)
    }
    
    @objc
    private func handleTap() {
        guard isActive else { return }
        onTap?()
    }
}

extension TrunButton {
    func apply() {
        if isActive && isSelected {
            titleLabel.text = title
            applyBorders(color: borderColor)
            titleLabel.textColor = titleColor
            self.backgroundColor = backroundThemedColor
            iconImageView?.image = iconModel?.image
            guard let color = iconModel?.tintColor else { return }
            iconImageView?.tintColor = color
        } else {
            titleLabel.text = titleInactive
            applyBorders(color: borderInactiveColor)
            titleLabel.textColor =  titleInactiveColor
            self.backgroundColor = backroundInactiveThemedColor
            iconImageView?.image = iconModel?.inactiveImage ?? iconModel?.image
            guard let color = iconModel?.tintInactiveColor else { return }
            iconImageView?.tintColor = color
        }
    }
}

extension TrunButton {
    struct IconModel {
        enum Position {
            case left
            case right
            case top
        }
        
        enum SizeLayout {
            case empty
            case fixed(size: CGSize)
            case scaled(x: CGFloat, y: CGFloat)
        }
        
        let position: Position
        let offset: CGFloat
        let sizelayout: SizeLayout
        let image: UIImage?
        let inactiveImage: UIImage?
        let tintColor: UIColor?
        let tintInactiveColor: UIColor?
        let contentMode: UIImageView.ContentMode?
        
        init(position: Position,
             offset: CGFloat,
             sizelayout: SizeLayout,
             image: UIImage? = nil,
             inactiveImage: UIImage? = nil,
             tintColor: UIColor? = nil,
             tintInactiveColor: UIColor? = nil,
             contentMode: UIImageView.ContentMode? = nil) {
            self.position = position
            self.offset = offset
            self.sizelayout = sizelayout
            self.image = image
            self.inactiveImage = inactiveImage
            self.tintColor = tintColor
            self.tintInactiveColor = tintInactiveColor
            self.contentMode = contentMode
        }
    }
}
