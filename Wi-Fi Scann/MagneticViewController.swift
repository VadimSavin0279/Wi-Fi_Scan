//
//  MagneticViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit

class MagneticViewController: UIViewController {
    private lazy var indicatorView: UIView = {
        let result = UIView()
        result.setDimension(.height, toSize: 8)
        result.applyBordersShape(width: 0, radius: 4)
        return result
    }()
    
    private lazy var indicatorLabel: UILabel = {
        let result = UILabel()
        result.font = .systemFont(ofSize: 32)
        result.text = "0 μT"
        result.textColor = Asset.Colors.greenGradientIndicator.color
        return result
    }()
    private lazy var detectButton: TrunButton = {
        let iconModel = TrunButton.IconModel(position: .left, offset: 4, sizelayout: .fixed(size: CGSize(width: 20, height: 22)), image: Asset.Assets.detectIcon.image, inactiveImage: Asset.Assets.stopIcon.image, contentMode: .scaleAspectFit)
        let result = TrunButton(title: "Detect",
                                titleColor: .white,
                                backroundColor: Asset.Colors.mainBlue.color,
                                titleInactive: "Stop",
                                titleInactiveColor: Asset.Colors.mainBlue.color,
                                backroundInactiveThemedColor: Asset.Colors.mainBlue.color.withAlphaComponent(0.15),
                                iconModel: iconModel)
        result.bordersWidth = 0
        result.isActive = true
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.whiteF2.color
        configureBottom()
        configureIndicator()
        detectButton.onTap = {
            self.detectButton.isSelected = !self.detectButton.isSelected
        }
    }
    
    private func configureBottom() {
        let label = UILabel()
        label.text = "Hidden Camera might be have strong magnetic field."
        label.font = .systemFont(ofSize: 15)
        label.textColor = Asset.Colors.gray3C.color.withAlphaComponent(0.6)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        let stackView = UIStackView(arrangedSubviews: [detectButton, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.distribution = .fill
        
        detectButton.match(.width, to: .width, of: stackView)
        
        view.addSubview(stackView)
        stackView.pinEdgesToSuperviewEdges(with: .init(top: 20, left: 20, bottom: 20, right: 20), excludingEdge: .top)
    }
    
    private func configureIndicator() {
        let bgViewIndicator = UIView()
        bgViewIndicator.backgroundColor = .white
        bgViewIndicator.applyBordersShape(width: 0, radius: 10)
        
        bgViewIndicator.addSubview(indicatorView)
        bgViewIndicator.setDimension(.height, toSize: 32)
        indicatorView.centerInSuperview()
        indicatorView.pinEdges(toSuperviewEdges: [.left, .right], withInset: 12)
        
        let bgIndicatorLabel = UIView()
        bgIndicatorLabel.backgroundColor = .white
        bgIndicatorLabel.applyBordersShape(width: 0, radius: 10)
        
        bgIndicatorLabel.addSubview(indicatorLabel)
        bgIndicatorLabel.setDimension(.width, toSize: 153, relation: .greaterThanOrEqual)
        indicatorLabel.pinEdge(toSuperviewEdge: .left, withInset: 25, relation: .greaterThanOrEqual)
        indicatorLabel.pinEdge(toSuperviewEdge: .right, withInset: 25, relation: .greaterThanOrEqual)
        indicatorLabel.pinEdges(toSuperviewEdges: [.top, .bottom], withInset: 16)
        indicatorLabel.centerInSuperview()
        
        let stackView = UIStackView(arrangedSubviews: [bgIndicatorLabel, bgViewIndicator])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.alignView(x: .center(offset: 0))
        stackView.pin(toTopLayoutGuideOf: self, withInset: 90)
        stackView.pinEdges(toSuperviewEdges: [.left, .right], withInset: 20)
        bgViewIndicator.pinEdges(toSuperviewEdges: [.right, .left])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Gradient.createGradient(with: .init(view: indicatorView,
                                            colors: [
                                                Asset.Colors.greenGradientIndicator.color,
                                                Asset.Colors.yellowGradientIndicator.color,
                                                Asset.Colors.redGradientIndicator.color
                                            ],
                                            location: [0, 0.5, 1]))
    }
}
