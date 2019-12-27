//
//  SignUpViewController.swift
//  Nailish
//
//  Created by Shota Iwamoto on 2019-12-23.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){

        view.backgroundColor = .white

        let logo = UIImageView(image: UIImage(named: "logo1"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let inputSV = UIStackView(arrangedSubviews: [emailText, passwordText, repeatPasswordText, invalidText, signUpButton, cancelButton])
        view.addSubview(inputSV)
        inputSV.axis = .vertical
        inputSV.spacing = 20
        inputSV.translatesAutoresizingMaskIntoConstraints = false

        inputSV.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        inputSV.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
        inputSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func SignUpTapped() {
        print("SignUpTapped")
        if(emailText.text == "" || passwordText.text == "" || repeatPasswordText.text == "") {
            invalidText.text = "Please input all field"
            return
        }
        if passwordText.text != repeatPasswordText.text {
            invalidText.text = "The password does not match!"
            return
        }

        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if (result?.user) != nil{
                    self.present(MainTabBarController(), animated: true, completion: nil)
                }
            }
        }
    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {

        if passwordText.isFirstResponder {
            self.view.frame.origin.y = -100
            return
        }
        if repeatPasswordText.isFirstResponder {
            self.view.frame.origin.y = -200
            return
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }


    // UIParts
    let emailText: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        return tf
    }()

    let passwordText: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.autocapitalizationType = .none
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return  tf
    }()

    let repeatPasswordText: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.autocapitalizationType = .none
        tf.placeholder = "Repeat Password"
        tf.isSecureTextEntry = true
        return  tf
    }()

    let invalidText: UILabel = {
        let lb = UILabel()
        lb.textColor = .red
        lb.textAlignment = .center
        return lb
    }()

    let signUpButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sing Up", for: .normal)
        bt.backgroundColor = .red
        bt.addTarget(self, action: #selector(SignUpTapped), for: .touchUpInside)
        return bt
    }()

    let cancelButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(.blue, for: .normal)
        bt.setTitle("Cancel", for: .normal)
        bt.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return bt
    }()

}
