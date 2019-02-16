//
//  UIColor+Extensions.swift
//  RssReader
//
//  Created by makeev on 09.02.2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var ultraLightGray: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    class var rssTextGray: UIColor {
        return UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    class var rssOrange: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 116.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    
    /// Returns nil if cgColor.components are nil or its count less that 3
    var hexString: String? {
        guard let components = self.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
    }
}
