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

        let logo = UIImageView(image: UIImage(named: "logo1"))
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let googleBtnSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 50))
        googleBtnSignIn.center = view.center
        googleBtnSignIn.style = .wide

        let inputSV = UIStackView(arrangedSubviews: [emailText, passwordText, invalidText, loginButton, googleBtnSignIn, orText, signUpButton])
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

    @objc func LoginTapped() {
        guard let email = emailText.text, let password = passwordText.text else {
            return
        }
        if email == "" || password == "" {
            invalidText.text = "Incorrect username or password."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil && error == nil) {
                self.mainTabBarController = MainTabBarController()
                self.present(self.mainTabBarController, animated: true, completion: nil)
            } else {
                self.invalidText.text = "Incorrect username or password."
            }
        }

    }

    @objc func SignUpTapped() {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {

        if passwordText.isFirstResponder {
            self.view.frame.origin.y = -100
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
        return  tf
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

    let invalidText: UILabel = {
        let lb = UILabel()
        lb.textColor = .red
        lb.textAlignment = .center
        return lb
    }()

    let orText: UILabel = {
        let lb = UILabel()
        lb.text = "or"
        lb.textAlignment = .center
        return lb
    }()

    let signUpButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sing up", for: .normal)
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
