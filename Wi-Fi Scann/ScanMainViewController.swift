//
//  ScanMainViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 18.09.2023.
//

import UIKit

class ScanMainViewController: UIViewController {
    private lazy var recheckButton: TrunButton = {
        let model = TrunButton.IconModel(position: .left,
                                         offset: 4,
                                         sizelayout: .fixed(size: CGSize(width: 16, height: 18)),
                                         image: Asset.Assets.recheckScanner.image,
                                         tintColor: Asset.Colors.mainBlue.color,
                                         tintInactiveColor: Asset.Colors.gray3C.color.withAlphaComponent(0.3))
        let result = TrunButton(title: "Recheck",
                                titleColor: Asset.Colors.mainBlue.color,
                                backroundColor: Asset.Colors.mainBlue.color.withAlphaComponent(0.3),
                                titleInactiveColor: Asset.Colors.gray3C.color.withAlphaComponent(0.3),
                                backroundInactiveThemedColor: Asset.Colors.gray76.color,
                                font: .systemFont(ofSize: 17),
                                iconModel: model,
                                height: 50)
        return result
    }()
    let progress = ProgressBar()
    let spinner = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = L10n.TabBar.scanner
        configure()
    }
    
    private func configure() {
        recheckButton.isActive = false
        recheckButton.bordersWidth = 0
        
        let stackViewButton = UIStackView(arrangedSubviews: [progress, recheckButton])
        stackViewButton.axis = .vertical
        stackViewButton.spacing = 16
        stackViewButton.distribution = .fillEqually
        
        let scanTitleLabel = UILabel()
        scanTitleLabel.text = "Suspicious device found: 0"
        scanTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        scanTitleLabel.sizeToFit()
        
        let wifiIpLabel = UILabel()
        wifiIpLabel.text = "WiFi IP: 10.121.80.48"
        wifiIpLabel.font = .systemFont(ofSize: 13)
        wifiIpLabel.sizeToFit()
        
        let stackViewLabel = UIStackView(arrangedSubviews: [scanTitleLabel, wifiIpLabel])
        stackViewLabel.axis = .vertical
        stackViewLabel.alignment = .center
        stackViewLabel.spacing = 4
        stackViewLabel.distribution = .fillProportionally
        
        let stackView = UIStackView(arrangedSubviews: [stackViewLabel, stackViewButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        
        view.addSubview(stackView)
        stackView.pin(toBottomLayoutGuideOf: self, withInset: 20)
        stackView.pinEdges(toSuperviewEdges: [.left, .right], withInset: 20)
        
        
        view.addSubview(spinner)
        spinner.pin(toTopLayoutGuideOf: self, withInset: 55)
        spinner.pinEdges(toSuperviewEdges: [.left, .right], withInset: 55)
        spinner.match(.height, to: .width, of: spinner)
        spinner.image = Asset.Assets.spinnerSanner.image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.startAnimation()
        spinner.rotate360Degrees(duration: 4)
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
