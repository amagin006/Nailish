//
//  AddAppointmentViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-29.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class AddAppointmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationUI()
    }
    
    private func setupUI() {
        view.addSubview(clientInfoView)
        clientInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        clientInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clientInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        clientInfoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedClientView))
        clientInfoView.addGestureRecognizer(gesture)
        clientInfoView.layer.shadowColor = UIColor.black.cgColor
        clientInfoView.layer.shadowOffset = CGSize(width: 4, height: 4)
        clientInfoView.layer.shadowRadius = 0.5
        clientInfoView.layer.masksToBounds = false
        clientInfoView.layer.shadowOpacity = 0.2
        
        let dateSV = UIStackView(arrangedSubviews: [dateTitleLabel, dateTextView])
        dateSV.axis = .horizontal
        dateSV.spacing = 20
        dateSV.translatesAutoresizingMaskIntoConstraints = false
        
        let startSV = UIStackView(arrangedSubviews: [startTitleLabel, startTextView])
        startSV.axis = .horizontal
        startSV.spacing = 50
        startSV.translatesAutoresizingMaskIntoConstraints = false
        
        let endSV = UIStackView(arrangedSubviews: [endTitleLabel, endTextView])
        endSV.axis = .horizontal
        endSV.spacing = 50
        endSV.translatesAutoresizingMaskIntoConstraints = false
        
        let timeSV = UIStackView(arrangedSubviews: [dateSV, startSV, endSV])
        timeSV.axis = .vertical
        timeSV.spacing = 10
        timeSV.translatesAutoresizingMaskIntoConstraints = false
        
        let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuTextView])
        menuSV.axis = .vertical
        menuSV.spacing = 5
        menuSV.translatesAutoresizingMaskIntoConstraints = false
        
        let memoSV = UIStackView(arrangedSubviews: [memoTitelLable, memoTextView])
        memoSV.axis = .vertical
        memoSV.spacing = 5
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        
        let formSV = UIStackView(arrangedSubviews: [timeSV, menuSV, memoSV])
        formSV.translatesAutoresizingMaskIntoConstraints = false
        formSV.spacing = 15
        formSV.axis = .vertical
        
        view.addSubview(formSV)
        formSV.topAnchor.constraint(equalTo: clientInfoView.bottomAnchor, constant: 30).isActive = true
        formSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        formSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    private func setupNavigationUI() {
        navigationItem.title = "Add Appointment"
        let cancelButton: UIBarButtonItem = {
            let bb = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
            return bb
        }()
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton: UIBarButtonItem = {
            let bb = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
            return bb
        }()
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func tappedClientView() {
        print("tappedClientView")
    }
    
    @objc func cancelButtonPressed() {
        print("cancelButtonPressed")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        print("save")
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        
        if menuTextView.isFirstResponder || memoTextView.isFirstResponder {
            self.view.frame.origin.y = -keyboardFrameHeight
        }
        else {
//            self.view.frame.origin.y = -keyboardFrameHeight
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    // UIParts
    private let clientInfoView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = #colorLiteral(red: 1, green: 0.8284288049, blue: 0.8181912303, alpha: 1)
        cv.layer.cornerRadius = 10
        cv.clipsToBounds = true
        return cv
    }()
    
    private let dateTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Date"
        return lb
    }()
    
    private let dateTextView: DatePickerKeyboard = {
        let dp = DatePickerKeyboard()
        dp.widthAnchor.constraint(equalToConstant: 180).isActive = true
        dp.textAlignment = NSTextAlignment.right
        dp.font = UIFont.systemFont(ofSize: 18)
        return dp
    }()
    
    private let startTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start"
        return lb
    }()
    
    private let startTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.right
        tp.widthAnchor.constraint(equalToConstant: 130).isActive = true
        return tp
    }()
    
    private let endTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "End"
        return lb
    }()
    
    private let endTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.right
        tp.widthAnchor.constraint(equalToConstant: 130).isActive = true
        return tp
    }()
    
    private let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        return lb
    }()
    
    private let menuTextView: MyTextView = {
        let tv = MyTextView()
        tv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return tv
    }()
    
    private let memoTitelLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "MEMO"
        return lb
    }()
    
    private let memoTextView: MyTextView = {
        let tv = MyTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return tv
    }()

}
