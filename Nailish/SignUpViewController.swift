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

        let inputSV = UIStackView(arrangedSubviews: [emailText, passwordText, signUpButton])
        view.addSubview(inputSV)
        inputSV.axis = .vertical
        inputSV.spacing = 20
        inputSV.translatesAutoresizingMaskIntoConstraints = false

        inputSV.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        inputSV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func SignUpTapped() {
        print("SignUpTapped")
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if (result?.user) != nil{
                    print("=====login=====")
                    self.present(MainTabBarController(), animated: true, completion: nil)
                }
            }
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
        return  tf
    }()

    let signUpButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sing Up", for: .normal)
        bt.backgroundColor = .red
        bt.addTarget(self, action: #selector(SignUpTapped), for: .touchUpInside)
        return bt
    }()



}
