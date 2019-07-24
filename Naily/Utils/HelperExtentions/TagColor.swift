//
//  TagColor.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-22.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

enum TagColor {
    case red
    case blue
    case green
    case purple
    case gray
}

//TagColor(rawValue: UIColor.red) // TagColor.red
//TagColor.red.description // "red"
//TagColor.stringToSGColor(str: "red")

extension TagColor: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case UIColor(red: 255/255, green: 123/255, blue: 123/255, alpha: 1): self = .red
        case UIColor(red: 123/255, green: 138/255, blue: 255/255, alpha: 1): self = .blue
        case UIColor(red: 121/255, green: 175/255, blue: 82/255, alpha: 1): self = .green
        case UIColor(red: 225/255, green: 123/255, blue: 255/255, alpha: 1): self = .purple
        case UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1): self = .gray
        default: return nil
        }
    }
    
    static func stringToSGColor(str: String) -> TagColor? {
        switch str {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "gray": return .gray
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .red: return UIColor(red: 255/255, green: 123/255, blue: 123/255, alpha: 1)
        case .blue: return UIColor(red: 123/255, green: 138/255, blue: 255/255, alpha: 1)
        case .green: return UIColor(red: 121/255, green: 175/255, blue: 82/255, alpha: 1)
        case .purple: return UIColor(red: 225/255, green: 123/255, blue: 255/255, alpha: 1)
        case .gray: return UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        }
    }
    
    var description: String {
        switch self {
        case .red: return "red"
        case .blue: return "blue"
        case .green: return "green"
        case .purple: return "purple"
        case .gray: return "gray"
        }
    }
}
