//
//  CustomDateToolbar.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CustomDateToolbar: UIToolbar {
    
    var didSelectDate: ((String, Bool) -> ())?
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let todayBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayPicker))
        return bt
    }()
    
    let doneBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isTranslucent = true
        sizeToFit()
        setItems([flexSpace, todayBtn, doneBtn], animated: true)
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDateStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        return formatter.string(from: datePicker.date)
    }
    
    @objc func doneButtonAction() {
        didSelectDate!(getDateStr(), true)
    }
    
    @objc private func todayPicker() {
        datePicker.date = Date()
        dateChanged()
    }
    
    @objc private func dateChanged() {
        didSelectDate!(getDateStr(), false)
    }
}

class CustomTimeToolbar: UIToolbar {

    var didSelectTime: ((String, Bool) -> ())?
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .time
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        return datePicker
    }()
    
    let doneBtn: UIBarButtonItem = {
        let bt = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        return bt
    }()
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isTranslucent = true
        sizeToFit()
        setItems([flexSpace, doneBtn], animated: true)
        self.datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTimeStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: datePicker.date)
    }
    
    @objc func doneButtonAction() {
        didSelectTime!(getTimeStr(), true)
    }
    
    @objc private func timeChanged() {
        didSelectTime!(getTimeStr(), false)
    }
}
