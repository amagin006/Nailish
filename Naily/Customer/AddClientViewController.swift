//
//  AddClientViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-03.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationUI()
    }
    
    private func setupUI() {
        
        view.addSubview(clientFormView)
        clientFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        clientFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        clientFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        clientFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.backgroundColor = .white
        clientFormView.addSubview(personImageView)
        personImageView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: clientFormView.topAnchor, constant: 20).isActive = true
        personImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        let hStackView = UIStackView(arrangedSubviews: [firstNameLabel, firstNameTextField, lastNameLabel, lastNameTextField, mailLabel, mailTextField, mobileLabel, mobileTextField, DOBLabel,DOBTextField, memoLabel, memoTextField])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        clientFormView.addSubview(hStackView)
        hStackView.axis = .vertical
        hStackView.backgroundColor = .white
        hStackView.distribution = .fillEqually
        
        hStackView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 20).isActive = true
        hStackView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor, multiplier: 0.8).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 10
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    private func setupNavigationUI() {
        navigationItem.title = "Add Client"
        let cancelButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
            return bt
        }()
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(seveButtonPressed))
            return bt
        }()
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func selectImage() {
        print("press selectImage")
    }
    
    @objc func seveButtonPressed() {
        print("saveButtonPressed")
        dismiss(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        print("cancelButtonPressed")
        dismiss(animated: true)
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if mailTextField.isFirstResponder || mobileTextField.isFirstResponder || DOBTextField.isFirstResponder || memoTextField.isFirstResponder {
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrameHeight = keyboardSize.cgRectValue.height
            print(notification)
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrameHeight

            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
 
        if mailTextField.isFirstResponder || mobileTextField.isFirstResponder || DOBTextField.isFirstResponder || memoTextField.isFirstResponder {
            guard let userInfo = notification.userInfo else { return }
            print(userInfo)
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardFrame.height
            }
        }
        
    }
    
    // MARK: - UIParts
    
    let clientFormView: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    lazy var personImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        iv.layer.cornerRadius = 80
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "First Name"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let firstNameTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "First Name..."
        return tf
    }()
    
    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Last Name"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let lastNameTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "Last Name..."
        return tf
    }()
    
    let mailLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Mail address"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let mailTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "example@example.com"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    
    let mobileLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Phone Number"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let mobileTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "000-000-0000"
        tf.keyboardType = UIKeyboardType.phonePad
        return tf
    }()
    
    let DOBLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Date of Birth"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let DOBTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "DD/MM/YYY"
        tf.keyboardType = UIKeyboardType.numbersAndPunctuation
        return tf
    }()
    
    let memoLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Memo"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let memoTextField: MyTextView = {
        let tv = MyTextView()
        return tv
    }()
    
}
