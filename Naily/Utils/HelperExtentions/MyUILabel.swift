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
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 6 + 6, height: size.height + 6 + 6)
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
