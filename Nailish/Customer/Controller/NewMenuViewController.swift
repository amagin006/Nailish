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
    var selectedColorTag = Int()
    var colorSelected = false
    
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
        menuNameTextField.addTarget(self, action: #selector(saveButtonValidation), for: .editingChanged)
        let menuNameSV = UIStackView(arrangedSubviews: [menuNameTitleLabel, menuNameTextField])
        menuNameSV.axis = .horizontal
        menuNameSV.distribution = .fillEqually
        menuNameSV.spacing = 10
        
        priceLabel.addTarget(self, action: #selector(saveButtonValidation), for: .editingChanged)
        let priceAmountSV = UIStackView(arrangedSubviews: [dollar, priceLabel])
        priceAmountSV.axis = .horizontal
        priceAmountSV.spacing = 3
        let priceSV = UIStackView(arrangedSubviews: [priceTitleLable, priceAmountSV])
        priceSV.axis = .horizontal
        priceSV.distribution = .fillEqually
        priceSV.spacing = 10
        
        taxLabel.addTarget(self, action: #selector(saveButtonValidation), for: .editingChanged)
        let taxAmountSV = UIStackView(arrangedSubviews: [taxLabel, percent])
        taxAmountSV.axis = .horizontal
        taxAmountSV.spacing = 3
        let taxSV = UIStackView(arrangedSubviews: [taxTitleLable, taxAmountSV])
        taxSV.axis = .horizontal
        taxSV.distribution = .fillEqually
        taxSV.spacing = 16
        
        let menuBoxSV = UIStackView(arrangedSubviews: [menuNameSV, priceSV, taxSV])
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
        colorSelected = true
        saveButtonValidation()
        selectColor = colorStr!
        selectedColorTag = sender.tag
    }
    
    @objc func saveTapped() {
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        
        let newSelectedItem = SelectedMenuItem(context: manageContext)
        newSelectedItem.menuName = menuNameTextField.text!
        newSelectedItem.price = priceLabel.amountDecimalNumber
        newSelectedItem.color = selectColor
        newSelectedItem.tag = Int16(selectedColorTag)
        newSelectedItem.tax = Decimal(string: taxLabel.text!) as NSDecimalNumber?
        do {
            try manageContext.save()
        } catch let err {
            print("failed save Report - \(err)")
        }
        dismiss(animated: true)
    }
    
    @objc func saveButtonValidation() {
        guard menuNameTextField.text != nil, priceLabel.text != nil, taxLabel.text != nil else { return }
        if menuNameTextField.text != "" && priceLabel.text != "" && taxLabel.text != "" && colorSelected {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
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
    
    let priceLabel: CurrencyTextField = {
        let tf = CurrencyTextField()
        tf.placeholder = "20.00"
        tf.textAlignment = .right
        tf.constraintWidth(equalToConstant: 120)
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    
    let taxTitleLable: UILabel = {
        let lb = UILabel()
        lb.text = "Tax"
        return lb
    }()
    
    let percent: UILabel = {
        let lb = UILabel()
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.text = "%"
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let taxLabel: taxTextField = {
        let tf = taxTextField()
        tf.placeholder = "5"
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        tf.constraintWidth(equalToConstant: 120)
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    

    let saveButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Save", for: .normal)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        bt.isEnabled = false
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
        bt.tag = 1
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
        bt.tag = 2
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
        bt.tag = 3
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
        bt.tag = 4
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
        bt.tag = 5
        return bt
    }()
}

