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
            menuitemTagLabel.backgroundColor = UIColor.hex(string: menuItem!.color ?? "#96CEB4", alpha: 1)
            priceLabel.text = String(menuItem!.price)
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
        addSubview(priceLabel)
        menuitemTagLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        menuitemTagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuitemTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
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
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "$ 70.00"
        return lb
    }()
    
}
