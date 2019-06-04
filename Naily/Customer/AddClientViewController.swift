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
        view.addSubview(personImageView)
        view.backgroundColor = .white
        personImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        
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
    
    private func setupUI() {
        
    }
    
    lazy var personImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        
        
        return iv
    }()

    
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
}
