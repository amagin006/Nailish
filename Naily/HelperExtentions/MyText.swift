//
//  MyTextField.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-05.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        self.inputAccessoryView = toolbar
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.isTranslucent = true
        tb.sizeToFit()
        return tb
    }()
    
    let doneBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddClientViewController.doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
}

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
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddClientViewController.doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
