//
//  LoginViewController.swift
//  Nailish
//
//  Created by Shota Iwamoto on 2019-12-23.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, UIApplicationDelegate, GIDSignInDelegate {

    var mainTabBarController = MainTabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)

        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                self.present(self.mainTabBarController, animated: true, completion: nil)
            }
        }
    }


    func setupUI(){

        view.backgroundColor = .white

        let btnSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 50))
        btnSignIn.center = view.center
        btnSignIn.style = .wide

        let inputSV = UIStackView(arrangedSubviews: [emailText, passwordText, loginButton, signUpButton, btnSignIn])
        view.addSubview(inputSV)
        inputSV.axis = .vertical
        inputSV.spacing = 20
        inputSV.translatesAutoresizingMaskIntoConstraints = false

        inputSV.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        inputSV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func LoginTapped() {
        mainTabBarController = MainTabBarController()
        self.present(mainTabBarController, animated: true, completion: nil)
    }

    @objc func SignUpTapped() {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }

    // UIParts

    let emailText: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        return  tf
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

    let loginButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Login", for: .normal)
        bt.backgroundColor = .blue
        bt.addTarget(self, action: #selector(LoginTapped), for: .touchUpInside)
        return bt
    }()


}
