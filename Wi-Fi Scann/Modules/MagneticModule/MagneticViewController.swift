//
//  MagneticViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit
import CoreLocation
import Combine

protocol MagneticViewControllerProtocol: AnyObject {
    func setFieldStrenght(_ value: String, color: UIColor)
}

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
        let result = TrunButton(title: L10n.Magnetic.detect,
                                titleColor: .white,
                                backroundColor: Asset.Colors.mainBlue.color,
                                titleInactive: L10n.Magnetic.stop,
                                titleInactiveColor: Asset.Colors.mainBlue.color,
                                backroundInactiveThemedColor: Asset.Colors.mainBlue.color.withAlphaComponent(0.15),
                                iconModel: iconModel)
        result.onTap = {
            if result.isSelected {
                Magnetometer.shared.start()
            } else {
                Magnetometer.shared.stop()
            }
            result.isSelected = !result.isSelected
        }
        result.bordersWidth = 0
        result.isActive = true
        return result
    }()
    
    private let presenter: MagneticPresenterProtocol
    
    init(presenter: MagneticPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Asset.Colors.whiteF2.color
        title = L10n.Magnetic.title
        presenter.viewDidLoad()
        
        configureBottom()
        configureIndicator()
    }
    
    private func configureBottom() {
        let label = UILabel()
        label.text = L10n.Magnetic.tip
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
        stackView.pin(toBottomLayoutGuideOf: self, withInset: 20)
        stackView.pinEdges(toSuperviewEdges: [.right, .left], withInset: 20)
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
        super.viewDidAppear(animated)
        Gradient.createGradient(with: .init(view: indicatorView,
                                            colors: [
                                                Asset.Colors.greenGradientIndicator.color,
                                                Asset.Colors.yellowGradientIndicator.color,
                                                Asset.Colors.redGradientIndicator.color
                                            ],
                                            location: [0, 0.5, 1]))
    }
}

extension MagneticViewController: MagneticViewControllerProtocol {
    func setFieldStrenght(_ value: String, color: UIColor) {
        UIView.transition(with: indicatorLabel, duration: 1, options: .transitionCrossDissolve) { [weak self] in
            self?.indicatorLabel.text = value
            self?.indicatorLabel.textColor = color
        }
    }
}
