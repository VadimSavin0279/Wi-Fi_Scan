//
//  CustomProgressBar.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 19.09.2023.
//

import UIKit

class ProgressBar: UIView {
    private lazy var fillView: UIView = {
        let result = UIView()
        result.backgroundColor = Asset.Colors.mainBlue.color
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        let str = NSAttributedString(string: "Checking...", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Asset.Colors.mainBlue.color
        ])
        result.attributedText = str
        result.sizeToFit()
        return result
    }()
    
    var widthAnchorConstraint: NSLayoutConstraint?
    var timer: Timer?
    
    init() {
        let label = UILabel()
        super.init(frame: .zero)
        configure()
    }
    
    func configure() {
        applyBordersShape(width: 1, radius: 8)
        applyBorders(color: Asset.Colors.mainBlue.color.withAlphaComponent(0.5))
        setDimension(.height, toSize: 50)
        
        addSubview(fillView)
        fillView.pinEdges(toSuperviewEdges: [.left, .bottom, .top])
        widthAnchorConstraint = fillView.setDimension(.width, toSize: 10)
        
        addSubview(titleLabel)
        titleLabel.centerInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func startAnimation() {
        widthAnchorConstraint?.constant = bounds.width
        UIView.animate(withDuration: 25.4, delay: 0, options: .curveLinear) {
            self.layoutIfNeeded()
        }
        var offset = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.67, repeats: true, block: { _ in
                UIView.transition(with: self.titleLabel, duration: 0.67, options: .transitionCrossDissolve) {
                    let str = "Checking..."
                    let endIndex = str.index(str.startIndex, offsetBy: offset)
                    let sbStr = str[str.startIndex..<endIndex]
                    let attrStr = NSAttributedString(string: String(sbStr), attributes: [
                        .font: UIFont.systemFont(ofSize: 17),
                        .foregroundColor: UIColor.white
                    ])
                    
                    let sbStr2 = str[endIndex..<str.endIndex]
                    let attrStr2 = NSAttributedString(string: String(sbStr2), attributes: [
                        .font: UIFont.systemFont(ofSize: 17),
                        .foregroundColor: Asset.Colors.mainBlue.color
                    ])
                    let strMut =  NSMutableAttributedString(attributedString: attrStr)
                    strMut.append(attrStr2)
                    self.titleLabel.attributedText = strMut
                    offset += 1
                    if offset == 12 {
                        self.timer?.invalidate()
                    }
                }
            })
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
