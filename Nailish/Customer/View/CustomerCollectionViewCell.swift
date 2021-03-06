//
//  CustomerCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-05-31.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CustomerCollectionViewCell: UICollectionViewCell {
    
    var clientInfo: ClientInfo! {
        didSet {
            if let imageDate = clientInfo.clientImage {
                cellImageView.image = UIImage(data: imageDate)
            }
            firstNameLabel.text = clientInfo.firstName!
            lastNameLabel.text = clientInfo.lastName!
        }
    }
    
    var clientReport: ReportItem! {
        didSet {
            if let lastVisit = clientReport.visitDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY/MM/dd"
                lastVistiDate.text = formatter.string(from: lastVisit)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        nameSV.translatesAutoresizingMaskIntoConstraints = false
        nameSV.axis = .horizontal
        nameSV.spacing = 10
        nameSV.alignment = .center
        
        let visitDaySV = UIStackView(arrangedSubviews: [lastVistDateLabel, lastVistiDate])
        visitDaySV.translatesAutoresizingMaskIntoConstraints = false
        visitDaySV.axis = .horizontal
        visitDaySV.spacing = 4
        
        let labelSV = UIStackView(arrangedSubviews: [nameSV, visitDaySV])
        labelSV.translatesAutoresizingMaskIntoConstraints = false
        labelSV.alignment = .leading
        labelSV.spacing = 4
        labelSV.axis = .vertical
        
        let cellSV = UIStackView(arrangedSubviews: [cellImageView, labelSV])
        cellSV.translatesAutoresizingMaskIntoConstraints = false
        cellSV.axis = .horizontal
        cellSV.alignment = .center
        cellSV.distribution = .fillProportionally
        cellSV.spacing = 10
        
        addSubview(cellSV)
        cellSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        cellSV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellSV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 30
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.clipsToBounds = true
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: "PrimaryText")
        return lb
    }()
    
    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: "PrimaryText")
        return lb
    }()
    
    let lastVistDateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Last Visit: "
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12.0)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    let lastVistiDate: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12.0)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 0.5
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
    }
    
    
    
}
