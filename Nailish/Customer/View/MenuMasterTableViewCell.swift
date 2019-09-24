//
//  MenuMasterTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-20.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MenuMasterTableViewCell: UITableViewCell {

//  var isFromSelectedMenuView: Bool? {
//      didSet {
//          if let _ = isFromSelectedMenuView {
//              menuAndCheckSV.insertArrangedSubview(selectCheckIcon, at: 0)
//          }
//      }
//  }
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
          taxLabel.text = "\(menuItem?.tax ?? 0)%"
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
      menuAndCheckSV.addArrangedSubview(quantityLabel)
      menuAndCheckSV.addArrangedSubview(menuitemTagLabel)

//      menuAndCheckSV.translatesAutoresizingMaskIntoConstraints = false
//      menuAndCheckSV.heightAnchor.constraint(equalToConstant: 30).isActive = true
//      menuAndCheckSV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//      menuAndCheckSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true

      let taxSV = UIStackView(arrangedSubviews: [taxTitleLabal, taxLabel])
      taxSV.alignment = .center
      taxSV.spacing = 4
      let itemPriceSV = UIStackView(arrangedSubviews: [dollar, priceLabel])
      itemPriceSV.alignment = .center
      itemPriceSV.spacing = 4
      let priceSV = UIStackView(arrangedSubviews: [itemPriceSV, taxSV])
      priceSV.translatesAutoresizingMaskIntoConstraints = false
      priceSV.alignment = .center
      priceSV.spacing = 8
    
      let menuAndPriceSV = UIStackView(arrangedSubviews: [menuAndCheckSV, priceSV])
      addSubview(menuAndPriceSV)
      menuAndPriceSV.spacing = 8
      menuAndPriceSV.translatesAutoresizingMaskIntoConstraints = false
      menuAndPriceSV.distribution = .equalCentering
      menuAndPriceSV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      menuAndPriceSV.heightAnchor.constraint(equalToConstant: 50).isActive = true
      menuAndPriceSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
      menuAndPriceSV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
//        priceSV.translatesAutoresizingMaskIntoConstraints = false
//        priceSV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        priceSV.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        priceSV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true

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

  let quantityLabel: UILabel = {
      let lb = UILabel()
      lb.font = UIFont.systemFont(ofSize: 22)
      lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      lb.text = "0"
      return lb
  }()

  let menuitemTagLabel: menuTagLabel = {
      let lb = menuTagLabel()
      lb.constraintHeight(equalToConstant: 27)
      lb.layer.cornerRadius = 12
      lb.clipsToBounds = true
      lb.textColor = .white
      return lb
  }()

  let taxTitleLabal: UILabel = {
      let lb = UILabel()
      lb.text = "tax"
      lb.font = UIFont.systemFont(ofSize: 12)
      return lb
  }()

  let taxLabel: UILabel = {
      let lb = UILabel()
      lb.text = "0%"
      lb.font = UIFont.systemFont(ofSize: 12)
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
