//
//  UIColor+Extension.swift
//  BookWorm
//
//  Created by 정준영 on 2023/08/01.
//

import UIKit.UIColor

extension UIColor {
    static func thickRandom() -> UIColor {
        let red = CGFloat.random(in: 0...0.5)
        let green = CGFloat.random(in: 0...0.5)
        let blue = CGFloat.random(in: 0...0.5)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func thinRandom() -> UIColor {
        let red = CGFloat.random(in: 0.5...0.9)
        let green = CGFloat.random(in: 0.5...0.9)
        let blue = CGFloat.random(in: 0.5...0.9)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
