//
//  MagneticPresenter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 25.09.2023.
//

import Foundation
import Combine

protocol MagneticPresenterProtocol {
    func viewDidLoad()
}

class MagneticPresenter {
    weak var view: MagneticViewControllerProtocol?
    private var labelSubscriber: AnyCancellable?
}

extension MagneticPresenter: MagneticPresenterProtocol {
    func viewDidLoad() {
        guard let view else { return }
        labelSubscriber = Magnetometer.shared.$magneticStrenght.sink(receiveValue: { result in
            let strValue = "\(result) μT"
            var color = Asset.Colors.greenGradientIndicator
            if result > 60 && result < 100 {
                color = Asset.Colors.lightGreenIndicator
            } else if result >= 100 && result <= 200 {
                color = Asset.Colors.yellowGradientIndicator
            } else if result > 200 && result < 300 {
                color = Asset.Colors.orangeIndicator
            } else if result >= 300{
                color = Asset.Colors.redGradientIndicator
            }
            view.setFieldStrenght(strValue, color: color.color)
        })
    }
}
