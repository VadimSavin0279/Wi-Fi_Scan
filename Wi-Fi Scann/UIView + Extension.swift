//
//  UIView + Extension.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 17.09.2023.
//

import UIKit

extension UIView {
    func applyBorders(color: UIColor?) {
        layer.borderColor = color?.cgColor
    }
    
    func applyBordersShape(width: CGFloat,
                           radius: CGFloat,
                           masksToBounds: Bool = true) {
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = masksToBounds
    }
}
