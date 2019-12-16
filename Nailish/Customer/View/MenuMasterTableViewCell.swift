//
//  MenuMasterTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-20.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MenuMasterTableViewCell: UITableViewCell {

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
          if let quantity = menuItem?.quantity {
              quantityLabel.text = String(quantity)
          }
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
      let tagcolor = self.menuitemTagLabel.backgroundColor
      super.setSelected(selected, animated: animated)
      self.menuitemTagLabel.backgroundColor = tagcolor
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    self.selectedBackgroundView = backgroundView
  }

  func setupUI() {
      let quantitySV = UIStackView(arrangedSubviews: [multipleLabel, quantityLabel])
      quantitySV.axis = .horizontal
      quantitySV.alignment = .lastBaseline
      quantitySV.spacing = -8

      addSubview(quantityAndMenuSV)
      quantityAndMenuSV.spacing = 10
      quantityAndMenuSV.axis = .horizontal
      quantityAndMenuSV.alignment = .center
      quantityAndMenuSV.addArrangedSubview(quantitySV)
      quantityAndMenuSV.addArrangedSubview(menuitemTagLabel)
      menuitemTagLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

      let taxSV = UIStackView(arrangedSubviews: [taxTitleLabal, taxLabel])
      taxSV.alignment = .center
      taxSV.spacing = 4
      let itemPriceSV = UIStackView(arrangedSubviews: [dollar, priceLabel])
      itemPriceSV.alignment = .center
      itemPriceSV.spacing = 4
      let priceSV = UIStackView(arrangedSubviews: [itemPriceSV, taxSV])
      priceSV.alignment = .center
      priceSV.spacing = 8
      priceSV.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    
      let menuAndPriceSV = UIStackView(arrangedSubviews: [quantityAndMenuSV, priceSV])
      addSubview(menuAndPriceSV)
      menuAndPriceSV.spacing = 8
      menuAndPriceSV.translatesAutoresizingMaskIntoConstraints = false
      menuAndPriceSV.distribution = .equalCentering
      menuAndPriceSV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      menuAndPriceSV.heightAnchor.constraint(equalToConstant: 50).isActive = true
      menuAndPriceSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
      menuAndPriceSV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
  }

  let quantityAndMenuSV: UIStackView = {
      let sv = UIStackView()
      return sv
  }()

  let multipleLabel: MyUILabel = {
    let lb = MyUILabel()
      lb.font = UIFont.systemFont(ofSize: 14)
      lb.text = "x"
      lb.textColor = UIColor(named: "PrimaryText")
      return lb
  }()

  let quantityLabel: MyUILabel = {
    let lb = MyUILabel()
      lb.font = UIFont.systemFont(ofSize: 22)
      lb.text = "0"
      lb.textColor = UIColor(named: "PrimaryText")
      return lb
  }()

  let menuitemTagLabel: menuTagLabel = {
      let lb = menuTagLabel()
      lb.constraintHeight(equalToConstant: 27)
      lb.layer.cornerRadius = 12
      lb.clipsToBounds = true
      return lb
  }()

  let taxTitleLabal: UILabel = {
      let lb = UILabel()
      lb.text = "tax"
      lb.textColor = UIColor(named: "PrimaryText")
      lb.font = UIFont.systemFont(ofSize: 12)
      return lb
  }()

  let taxLabel: UILabel = {
      let lb = UILabel()
      lb.text = "0%"
      lb.textColor = UIColor(named: "PrimaryText")
      lb.font = UIFont.systemFont(ofSize: 12)
      return lb
  }()

  let dollar: UILabel = {
      let lb = UILabel()
      lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      lb.text = "$"
      lb.textColor = UIColor(named: "PrimaryText")
      lb.font = UIFont.systemFont(ofSize: 16)
      return lb
  }()
    
  let priceLabel: UILabel = {
      let lb = UILabel()
      lb.textColor = UIColor(named: "PrimaryText")
      lb.translatesAutoresizingMaskIntoConstraints = false
      return lb
  }()
}
