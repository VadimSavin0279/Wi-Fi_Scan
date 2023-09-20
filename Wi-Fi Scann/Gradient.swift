//
//  Gradient.swift
//  reblackrussia
//
//  Created by Вадим on 25.08.2023.
//

import Foundation
import UIKit

class Gradient {
    struct GradientModel {
        let view: UIView?
        let frame: CGRect
        let colors: [CGColor]
        var startPoint: CGPoint?
        var endPoint: CGPoint?
        let location: [NSNumber]
        let type: CAGradientLayerType
        
        init(view: UIView? = nil,
             frame: CGRect = .zero,
             colors: [UIColor] = [],
             startPoint: CGPoint? = nil,
             endPoint: CGPoint? = nil,
             location: [NSNumber] = [0, 1],
             type: CAGradientLayerType = .axial) {
            self.view = view
            if let view = view, frame == .zero {
                self.frame = view.bounds
            } else {
                self.frame = frame
            }
            self.colors = colors.map { $0.cgColor }
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.location = location
            self.type = type
        }
    }
    
    @discardableResult
    static func createGradient(with model: GradientModel) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.type = model.type
        gradient.startPoint = model.startPoint ?? (model.type == .axial ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0.5))
        gradient.endPoint = model.endPoint ?? (model.type == .axial ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 1, y: 1))
        gradient.locations = model.location
        gradient.zPosition = -1
        gradient.colors = model.colors
        gradient.frame = model.frame
        model.view?.layer.addSublayer(gradient)
        return gradient
    }
}
