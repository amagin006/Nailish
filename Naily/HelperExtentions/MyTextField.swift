//
//  MyTextField.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-05.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
}
