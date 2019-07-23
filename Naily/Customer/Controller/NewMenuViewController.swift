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
    var selectColor = String()
    
    var menuItem: MenuItem! {
        didSet {
            menuNameTextField.text = menuItem.menuName
//            priceLable.text = String(menuItem.price)
            if let colorStr = menuItem.color {
                let color = TagColor.stringToSGColor(str: colorStr)
                for button in selectButtonArr {
                    if button.backgroundColor == color?.rawValue {
                        button.setImage(#imageLiteral(resourceName: "check-icon2"), for: .normal)
                        selectColor = colorStr
                    }
                }
            }
        }
    }

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
        
        let priceAmountSV = UIStackView(arrangedSubviews: [dollar, priceLable, dot, priceDecimalLable])
        priceAmountSV.axis = .horizontal
        priceAmountSV.spacing = 3
        let priceSV = UIStackView(arrangedSubviews: [priceTitleLable, priceAmountSV])
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
        for button in selectButtonArr {
            button.setImage(#imageLiteral(resourceName: "clear"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "check-icon2"), for: .normal)
        sender.imageView?.contentMode = .scaleAspectFit
        sender.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let color = sender.backgroundColor!
        let colorStr = TagColor(rawValue: color)?.description
        selectColor = colorStr!
        print(selectColor)
    }
    
    @objc func saveTapped() {
        print("saveTapped")
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        if menuItem == nil {
            let newMenuItem = NSEntityDescription.insertNewObject(forEntityName: "MenuItem", into: manageContext)
            newMenuItem.setValue(menuNameTextField.text!, forKey: "menuName")
            let priceDec = priceDecimalLable.text ?? "0"
            let priceDecStr = String(priceDec.prefix(2))
            
            let price = "\(priceLable.text ?? "0").\(priceDecStr)"
            print(price)
            newMenuItem.setValue(price, forKey: "price")
            newMenuItem.setValue(selectColor, forKey: "color")
            do {
                try fetchedMenuItemResultsControllerr.managedObjectContext.save()
            } catch let err {
                print("failed save Report - \(err)")
            }
            dismiss(animated: true, completion: {
                
            })
        }
    }
    
    lazy var fetchedMenuItemResultsControllerr: NSFetchedResultsController = { () -> NSFetchedResultsController<MenuItem> in
        let fetchRequest = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        let nameDescriptors = NSSortDescriptor(key: "color", ascending: true)
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
    
    let dollar: UILabel = {
        let lb = UILabel()
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.text = "$"
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let priceLable: MyTextField = {
        let tf = MyTextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "20"
        tf.constraintWidth(equalToConstant: 60)
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    
    let dot: UILabel = {
        let lb = UILabel()
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.text = "."
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let priceDecimalLable: MyTextField = {
        let tf = MyTextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "00"
        tf.constraintWidth(equalToConstant: 50)
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
        bt.backgroundColor = UIColor(red: 255/255, green: 123/255, blue: 123/255, alpha: 1)
        return bt
    }()
    
    let color2: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 123/255, green: 138/255, blue: 255/255, alpha: 1)
        return bt
    }()
    
    let color3: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 121/255, green: 175/255, blue: 82/255, alpha: 1)
        return bt
    }()
    
    let color4: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 225/255, green: 123/255, blue: 255/255, alpha: 1)
        return bt
    }()
    
    let color5: UIButton = {
        let bt = UIButton()
        bt.constraintWidth(equalToConstant: 40)
        bt.constraintHeight(equalToConstant: 40)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(selectColorTap(_:)), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        return bt
    }()
    
    
    

}

