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
        clientFormView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        clientFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        clientFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        clientFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.backgroundColor = .white
        clientFormView.addSubview(personImageView)
        personImageView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: clientFormView.topAnchor, constant: 30).isActive = true
        personImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let hStackView = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel, mailLabel])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        clientFormView.addSubview(hStackView)
        hStackView.axis = .vertical
        hStackView.backgroundColor = .white
        
        hStackView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 20).isActive = true
        hStackView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor, multiplier: 0.8).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 10
        
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
    
    
    // MARK: - UIParts
    
    let clientFormView: UIScrollView = {
        let vi = UIScrollView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.contentSize.height = 5000
        vi.backgroundColor = .blue
        return vi
    }()
    
    lazy var personImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        iv.layer.cornerRadius = 100
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    let firstNameLabel: MyTextField = {
        let tf = MyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.placeholder = "First Name..."
        return tf
    }()
    
    let lastNameLabel: MyTextField = {
        let tf = MyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.placeholder = "Last Name..."
        return tf
    }()
    
    let mailLabel: MyTextField = {
        let tf = MyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.placeholder = "Mail adress..."
        return tf
    }()
    
}
