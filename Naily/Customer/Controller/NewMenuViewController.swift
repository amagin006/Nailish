//
//  NewMenuViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-21.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class NewMenuViewController: UIViewController {
    
    var selectButtonArr = [UIButton]()
    var selectColor = UIColor.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationUI()
        setupUI()
    }
    
    
    func setupNavigationUI() {
        navigationItem.title = "Select Menu"
        let cancelButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(newMenuCancelButton))
            return bt
        }()
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupUI() {
        let menuNameSV = UIStackView(arrangedSubviews: [menuNameTitleLabel, menuNameTextField])
        menuNameSV.axis = .horizontal
        menuNameSV.distribution = .fillEqually
        menuNameSV.spacing = 10
        let priceSV = UIStackView(arrangedSubviews: [priceTitleLable, priceLable])
        priceSV.axis = .horizontal
        priceSV.distribution = .fillEqually
        priceSV.spacing = 10
        
        let menuBoxSV = UIStackView(arrangedSubviews: [menuNameSV, priceSV])
        menuBoxSV.axis = .vertical
        menuBoxSV.spacing = 10
        
        view.addSubview(menuBoxSV)
        menuBoxSV.translatesAutoresizingMaskIntoConstraints = false
        menuBoxSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        menuBoxSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        menuBoxSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let colorSV = UIStackView(arrangedSubviews: [color1, color2, color3, color4, color5])
        selectButtonArr.append(color1)
        selectButtonArr.append(color2)
        selectButtonArr.append(color3)
        selectButtonArr.append(color4)
        selectButtonArr.append(color5)
        colorSV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorSV)
        colorSV.distribution = .equalSpacing
        colorSV.axis = .horizontal
        
        colorSV.topAnchor.constraint(equalTo: menuBoxSV.bottomAnchor, constant: 30).isActive = true
        colorSV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        colorSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: colorSV.bottomAnchor, constant: 30).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func newMenuCancelButton() {
        print("newMenuCancelButton")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectColorTap(_ sender: UIButton) {
        print("selectColorTap \(sender)")
        for button in selectButtonArr {
            button.setImage(#imageLiteral(resourceName: "clear"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "check-icon2"), for: .normal)
        sender.imageView?.contentMode = .scaleAspectFit
        sender.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        selectColor = sender.backgroundColor!
        print(selectColor)
        
    }
    
    @objc func saveTapped() {
        print("saveTapped")
    }
    
    lazy var fetchedMenuItemResultsControllerr: NSFetchedResultsController = { () -> NSFetchedResultsController<MenuItem> in
        let fetchRequest = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        let nameDescriptors = NSSortDescriptor(key: "MenuName", ascending: true)
        fetchRequest.sortDescriptors = [nameDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    // UI Parts
    let menuNameTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu Name"
        return lb
    }()
    
    let menuNameTextField: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    
    let priceTitleLable: UILabel = {
        let lb = UILabel()
        lb.text = "Price"
        return lb
    }()
    
    let priceLable: MyTextField = {
        let tf = MyTextField()
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    
    let saveButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Save", for: .normal)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.constraintWidth(equalToConstant: 100)
        bt.constraintHeight(equalToConstant: 40)
        bt.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        bt.setBackgroundColor(UIColor(red: 255/255, green: 137/255, blue: 137/255, alpha: 1), for: .normal)
        return bt
    }()
    
    let color1: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 255/255, green: 92/255, blue: 92/255, alpha: 1)
        return bt
    }()
    
    let color2: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 123/255, green: 92/255, blue: 255/255, alpha: 1)
        return bt
    }()
    
    let color3: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 103/255, green: 180/255, blue: 129/255, alpha: 1)
        return bt
    }()
    
    let color4: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 245/255, green: 222/255, blue: 143/255, alpha: 1)
        return bt
    }()
    
    let color5: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: 1)
        return bt
    }()
    
    
    

}
