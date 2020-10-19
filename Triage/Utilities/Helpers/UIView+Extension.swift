//
//  UIView+Extension.swift
//  Triage
//
//  Created by Tamer Bader on 8/11/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -10.0, 10.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
