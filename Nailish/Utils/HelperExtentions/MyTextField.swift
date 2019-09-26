//
//  MyTextField.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-05.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyTextField: UITextField, UITextFieldDelegate {
    
    let toolbar = CustomDoneToolbar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        self.inputAccessoryView = toolbar
        self.delegate = self
        toolbar.donePress = { () in
            self.endEditing(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 10.0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 10.0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 10.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

class CurrencyTextField: MyTextField {
    var amountDecimalNumber: NSDecimalNumber = 0.00
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(currencyFieldDidChange), for: .editingChanged)
        self.keyboardType = .decimalPad
        self.textColor = UIColor(named: "PrimaryText")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func currencyFieldDidChange() {
        if let amountString = self.text?.getCurrencyStringFormatting() {
            self.text = amountString
        }
        if let amountDecimal = self.text?.getCurrencyDecimalFormatting() {
            self.amountDecimalNumber = amountDecimal
        }
    }
}

class taxTextField: MyTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardType = .decimalPad
        self.textColor = UIColor(named: "PrimaryText")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 3
    }
}
