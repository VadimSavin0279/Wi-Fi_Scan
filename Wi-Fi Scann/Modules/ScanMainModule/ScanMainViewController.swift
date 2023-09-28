//
//  ScanMainViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 18.09.2023.
//

import UIKit

protocol ScanMainViewControllerProtocol: AnyObject {
    func setTextDeviceFound(_ text: String)
}

class ScanMainViewController: UIViewController {
    private lazy var recheckButton: TrunButton = {
        let model = TrunButton.IconModel(position: .left,
                                         offset: 4,
                                         sizelayout: .fixed(size: CGSize(width: 16, height: 18)),
                                         image: Asset.Assets.recheckScanner.image,
                                         tintColor: Asset.Colors.mainBlue.color,
                                         tintInactiveColor: Asset.Colors.gray3C.color.withAlphaComponent(0.3))
        let result = TrunButton(title: L10n.ScanMain.recheck,
                                titleColor: Asset.Colors.mainBlue.color,
                                backroundColor: Asset.Colors.mainBlue.color.withAlphaComponent(0.15),
                                titleInactiveColor: Asset.Colors.gray3C.color.withAlphaComponent(0.3),
                                backroundInactiveThemedColor: Asset.Colors.gray76.color,
                                font: .systemFont(ofSize: 17),
                                iconModel: model,
                                height: 50)
        result.isActive = false
        result.bordersWidth = 0
        return result
    }()
    
    private lazy var startButton: TrunButton = {
        let model = TrunButton.IconModel(position: .left,
                                         offset: 4,
                                         sizelayout: .fixed(size: CGSize(width: 25, height: 18)),
                                         image: Asset.Assets.viewResultsButton.image,
                                         inactiveImage: Asset.Assets.startButton.image,
                                         contentMode: .scaleAspectFit)
        let result = TrunButton(title: L10n.ScanMain.results,
                                titleColor: .white,
                                backroundColor: Asset.Colors.mainBlue.color,
                                titleInactive: L10n.ScanMain.start,
                                titleInactiveColor: .white,
                                backroundInactiveThemedColor: Asset.Colors.mainBlue.color,
                                font: .systemFont(ofSize: 17),
                                iconModel: model,
                                height: 50)
        result.isSelected = false
        result.bordersWidth = 0
        return result
    }()
    
    private lazy var scanTitleLabel: UILabel = {
        let result = UILabel()
        result.text = L10n.ScanMain.deviceFound
        result.font = .systemFont(ofSize: 20, weight: .semibold)
        result.sizeToFit()
        result.isHidden = true
        return result
    }()
    
    private lazy var wifiIpLabel: UILabel = {
        let result = UILabel()
        result.text = L10n.ScanMain.wiFiIP
        result.font = .systemFont(ofSize: 13)
        result.sizeToFit()
        result.isHidden = true
        return result
    }()
    
    private lazy var progress: ProgressBar = {
        let result = ProgressBar()
        result.onEnd = { [weak self] in
            self?.startButton.isHidden = false
            self?.recheckButton.isActive = true
            self?.spinner.layer.removeAllAnimations()
            self?.setTextWiFiIP("192.168.1.1")
        }
        return result
    }()
    
    private lazy var spinner = UIImageView()
    
    private let presenter: ScanMainPresenterProtocol
    
    init(presenter: ScanMainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (navigationController as? NavigationController)?.hideCustomBottomLine(true)
    }
    
    private func configure() {
        view.backgroundColor = .white
        title = L10n.TabBar.scanner
        
        progress.addSubview(startButton)
        startButton.pinEdgesToSuperviewEdges()
        
        let stackViewButton = UIStackView(arrangedSubviews: [progress, recheckButton])
        stackViewButton.axis = .vertical
        stackViewButton.spacing = 16
        stackViewButton.distribution = .fillEqually
        
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
    
    private func configureAction() {
        startButton.onTap = { [weak self] in
            if self?.startButton.isSelected == false {
                self?.startScan()
                self?.presenter.startStopScan(value: true)
            } else {
                self?.presenter.openResults()
            }
        }
        
        recheckButton.onTap = { [weak self] in
            self?.startScan()
            self?.presenter.startStopScan(value: true)
        }
    }
    
    private func startScan() {
        recheckButton.isActive = false
        startButton.isSelected = true
        startButton.isHidden = true
        wifiIpLabel.isHidden = true
        scanTitleLabel.isHidden = true
        
        progress.startAnimation()
        spinner.rotate360Degrees(duration: 4)
    }
    
    private func setTextWiFiIP(_ text: String) {
        wifiIpLabel.text = L10n.ScanMain.wiFiIP + text
        wifiIpLabel.isHidden = false
    }
}

extension ScanMainViewController: ScanMainViewControllerProtocol {
    internal func setTextDeviceFound(_ text: String) {
        scanTitleLabel.text =  L10n.ScanMain.deviceFound + text
        scanTitleLabel.isHidden = false
    }
}
