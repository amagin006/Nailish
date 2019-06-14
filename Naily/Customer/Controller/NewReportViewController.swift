//
//  AddReportViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-13.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class NewReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(formScrollView)
        formScrollView.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
        formScrollView.contentSize.width = UIScreen.main.bounds.width

        formScrollView.addSubview(reportMainImageView)
        reportMainImageView.topAnchor.constraint(equalTo: formScrollView.topAnchor).isActive = true
        reportMainImageView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor).isActive = true
        reportMainImageView.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        reportMainImageView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        
        formScrollView.addSubview(subImageSV)
        subImageSV.distribution = .fillEqually
        subImageSV.spacing = 10
        subImageSV.topAnchor.constraint(equalTo: reportMainImageView.bottomAnchor, constant: 10).isActive = true
        subImageSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        subImageSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        subImageSV.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        for _ in 0..<3 {
            let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))
            iv.layer.borderWidth = 2
            iv.layer.borderColor = UIColor.lightGray.cgColor
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
            subImageSV.addArrangedSubview(iv)
        }
        
        let addImageView = UIImageView(image: #imageLiteral(resourceName: "addicon2"))
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        addImageView.isUserInteractionEnabled = true
        addImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewImageSelect)))
        subImageSV.addArrangedSubview(addImageView)
        
        let discriptionSV = UIStackView(arrangedSubviews: [
            vistTitleLabel, visitTextField, menuTitleLabel, menuTextField, priceTitleLabel, priceTextField, memoLabel,
            memoTextView])
        discriptionSV.translatesAutoresizingMaskIntoConstraints = false
        discriptionSV.axis = .vertical
        discriptionSV.spacing = 3
        discriptionSV.alignment = .fill
        formScrollView.addSubview(discriptionSV)
        
        discriptionSV.topAnchor.constraint(equalTo: subImageSV.bottomAnchor, constant: 10).isActive = true
        discriptionSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        discriptionSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    private func setupNavigationUI() {
        navigationItem.title = "New Report"
        let cancelButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(reportCancelButtonPressed))
            return bt
        }()
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(reportSeveButtonPressed))
            return bt
        }()
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        print("ImageSelect")
    }
    
    @objc func addNewImageSelect() {
        print("addImageSelect")
    }
    
    @objc func reportCancelButtonPressed() {
        print("reportCancelButtonPressed")
        dismiss(animated: true)
    }
    
    @objc func reportSeveButtonPressed() {
        print("reportSeveButtonPressed")
        dismiss(animated: true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrameHeight
        }
    
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        print(userInfo)
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
        }
    
        
    }
    
    // UIParts
    
    let formScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
//        sv.contentSize.height = 2000
        return sv
    }()
    
    let reportMainImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let subImageSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let vistTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Visit Day"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()

    let visitTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let menuTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let priceTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "price"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let priceTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let memoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()

    let memoTextView: MyTextView = {
        let tv = MyTextView()
        tv.font = UIFont.systemFont(ofSize: 18)
       
        return tv
    }()

}
