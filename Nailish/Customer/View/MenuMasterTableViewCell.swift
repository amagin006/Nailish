//
//  MenuMasterTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-20.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MenuMasterTableViewCell: UITableViewCell {

    var tapped = false
    var isFromSelectedMenuView: Bool? {
        didSet {
            if let _ = isFromSelectedMenuView {
                menuAndCheckSV.insertArrangedSubview(selectCheckIcon, at: 0)
            }
        }
    }
    var menuItem: SelectedMenuItem? {
        didSet {
            menuitemTagLabel.text = menuItem!.menuName ?? ""
            if let price = menuItem?.price {
                let fm = NumberFormatter()
                fm.numberStyle = .decimal
                fm.maximumFractionDigits = 2
                fm.minimumFractionDigits = 2
                priceLabel.text = fm.string(from: price)
            }
            let color = TagColor.stringToSGColor(str: menuItem!.color!)
            menuitemTagLabel.backgroundColor = color!.rawValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "menuCell")
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.menuitemTagLabel.backgroundColor
        super.setSelected(selected, animated: animated)
        self.menuitemTagLabel.backgroundColor = color
    }

    func setupUI() {
        addSubview(menuAndCheckSV)
        menuAndCheckSV.spacing = 16
        menuAndCheckSV.axis = .horizontal
        menuAndCheckSV.alignment = .center
        menuAndCheckSV.addArrangedSubview(menuitemTagLabel)
        menuAndCheckSV.translatesAutoresizingMaskIntoConstraints = false
        menuAndCheckSV.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuAndCheckSV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuAndCheckSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        let priceSV = UIStackView(arrangedSubviews: [dollar, priceLabel])
        priceSV.axis = .horizontal
        priceSV.alignment = .center
        priceSV.spacing = 4
        addSubview(priceSV)
        priceSV.translatesAutoresizingMaskIntoConstraints = false
        priceSV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceSV.heightAnchor.constraint(equalToConstant: 50).isActive = true
        priceSV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
    }
    
    let menuAndCheckSV: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    let selectCheckIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "check-icon4")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.constraintWidth(equalToConstant: 27)
        iv.constraintHeight(equalToConstant: 27)
        return iv
    }()

    let menuitemTagLabel: menuTagLabel = {
        let lb = menuTagLabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.constraintHeight(equalToConstant: 27)
        lb.backgroundColor = .blue
        lb.layer.cornerRadius = 12
        lb.clipsToBounds = true
        lb.textColor = .white
        return lb
    }()
    
    let dollar: UILabel = {
        let lb = UILabel()
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.text = "$"
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
}
