//
//  MyUILabel.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-27.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyUILabel: UILabel {
    let padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }

}

class menuTagLabel: UILabel {
    
    let padding = UIEdgeInsets(top: 2, left: 14, bottom: 2, right: 14)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }
    
}


class UnderlineUILabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
}
