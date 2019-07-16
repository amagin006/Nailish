//
//  MyTextView.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MyTextView: UITextView, UITextViewDelegate {
    
    let toolbar = CustomDoneToolbar()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 14)
        self.inputAccessoryView = toolbar
        toolbar.donePress = { () in
            self.endEditing(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Memo here..." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Memo here..."
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        var frame = textView.frame
//        frame.size.height = textView.contentSize.height
//        textView.frame = frame
//    }
//
}
