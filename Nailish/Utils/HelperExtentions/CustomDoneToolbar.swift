//
//  CustomDoneToolbar.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-14.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CustomDoneToolbar: UIToolbar {
    
    var donePress: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setItems([flexSpace, doneBtn], animated: true)
        sizeToFit()
        isTranslucent = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let doneBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    @objc func doneButtonAction() {
        donePress!()
    }
}
