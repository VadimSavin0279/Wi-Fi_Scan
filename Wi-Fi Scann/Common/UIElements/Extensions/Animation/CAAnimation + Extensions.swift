//
//  CAAnimation + Extensions.swift
//  MoonApp
//
//  Created by Вадим on 31.07.2023.
//

import Foundation
import QuartzCore

extension CABasicAnimation {
    convenience init(keyPath: String?, fromValue: Any, toValue: Any, duration: CFTimeInterval, beginTime: CFTimeInterval) {
        self.init(keyPath: keyPath)
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.beginTime = beginTime
    }
}

extension CAAnimationGroup {
    convenience init(animations: [CAAnimation], duration: CFTimeInterval, repeatCount: Float = .greatestFiniteMagnitude, beginTime: CFTimeInterval) {
        self.init()
        self.animations = animations
        self.duration = duration
        self.repeatCount = repeatCount
        self.beginTime = beginTime
    }
}
