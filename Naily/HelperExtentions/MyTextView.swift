//
//  MyTextView.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.font = UIFont.systemFont(ofSize: 14)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        self.inputAccessoryView = toolbar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.isTranslucent = true
        tb.sizeToFit()
        return tb
    }()
    
    let doneBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
    
}
