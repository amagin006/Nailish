//
//  Extensions.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension String {
    func remove(characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    func currencyInputFormatting() -> NSNumber {
        var number: NSNumber!
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        return number
    }

    
    // formatting text for currency textField
    func getCurrencyStringFormatting() -> String {
        let number = currencyInputFormatting()
        let fm = NumberFormatter()
        fm.numberStyle = .decimal
        //        fm.currencySymbol = "$"
        fm.maximumFractionDigits = 2
        fm.minimumFractionDigits = 2
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        return fm.string(from: number)!
    }
    
    func getCurrencyDecimalFormatting() -> NSDecimalNumber {
        let number = currencyInputFormatting()
        guard number != 0 as NSNumber else {
            return 0
        }
        return NSDecimalNumber(decimal: number.decimalValue)
    }

    
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = color.image
        setBackgroundImage(image, for: state)
    }
}

extension UIColor {
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func hex(string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
    
}

