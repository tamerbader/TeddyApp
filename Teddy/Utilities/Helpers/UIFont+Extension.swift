//
//  UIFont+Extension.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit

public enum FontStyle: String {
    case AspiraBold = "Aspira-Bold"
    case AspiraDemi = "Aspira-Demi"
    case AspiraLight = "Aspira-Light"
    case AspiraMedium = "Aspira-Medium"
    case AspiraRegular  = "Aspira-Regular"
    case AspiraThin = "Aspira-Thin"
}

extension UIFont {
    public convenience init?(fontStyle: FontStyle, size: CGFloat) {
        self.init(name: fontStyle.rawValue, size: size)
    }
}
