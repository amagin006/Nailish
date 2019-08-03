//
//  MyNormalTextField.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-14.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyNormalTextField: UITextField, UITextFieldDelegate {
    
    let toolbar = CustomDoneToolbar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.inputAccessoryView = toolbar
        self.delegate = self
        toolbar.donePress = { () in
            self.endEditing(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
