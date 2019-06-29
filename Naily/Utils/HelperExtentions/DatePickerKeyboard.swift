//
//  DatePickerKeyboard.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit



class DatePickerKeyboard: UITextView, UITextViewDelegate {
    
    let toolbar = CustomDateToolbar()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDatePicker()
        // closure (function without name)
        toolbar.didSelectDate = { (text, dismiss) in
            self.text = text
            if dismiss {
                self.endEditing(true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDatePicker() {
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 14)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        self.inputView = toolbar.datePicker
        self.inputAccessoryView = toolbar
        self.delegate = self
    }


    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}

class MyPaddingLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}

