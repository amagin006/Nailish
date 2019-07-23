//
//  MenuMasterTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-20.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MenuMasterTableViewCell: UITableViewCell {
    
    var menuItem: MenuItem? {
        didSet {
            menuitemTagLabel.text = menuItem!.menuName ?? ""
            priceLabel.text = menuItem!.price
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
        addSubview(menuitemTagLabel)

        menuitemTagLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        menuitemTagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuitemTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60).isActive = true
        
        let priceSV = UIStackView(arrangedSubviews: [dollar, priceLabel])
        priceSV.axis = .horizontal
        priceSV.spacing = 4
        addSubview(priceSV)
        priceSV.translatesAutoresizingMaskIntoConstraints = false
        priceSV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceSV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        priceSV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
    }

    let checkicon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "check-icon2")
        return iv
    }()

    let menuitemTagLabel: menuTagLabel = {
        let lb = menuTagLabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = .blue
        lb.layer.cornerRadius = 12
        lb.clipsToBounds = true
        lb.textColor = .white
        lb.text = "Design"
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
