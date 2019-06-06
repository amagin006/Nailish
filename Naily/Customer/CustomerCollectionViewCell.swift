//
//  CustomerCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-05-31.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CustomerCollectionViewCell: UICollectionViewCell {
    
    var clientItem: ClientItem! {
        didSet {
            cellImageView.image = clientItem.image
            nameLabel.text = clientItem.clientName
            lastVistiDate.text = clientItem.lastVisitDate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStackView = UIStackView(arrangedSubviews: [cellImageView, nameLabel, lastVistiDate])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .horizontal
        labelStackView.alignment = .center
        labelStackView.distribution = .fill
        
        labelStackView.spacing = 10
        
        addSubview(labelStackView)
        labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        labelStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        backgroundColor = #colorLiteral(red: 1, green: 0.8284288049, blue: 0.8181912303, alpha: 1)
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let cellImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "beautiful-blur-blurred-background-733872"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 30
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let lastVistiDate: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/21"
        lb.widthAnchor.constraint(equalToConstant: 100)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 14.0)
        return lb
    }()
    
    
    
}
