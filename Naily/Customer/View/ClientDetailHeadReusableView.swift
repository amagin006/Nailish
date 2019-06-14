//
//  ClientDetailHeadCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

protocol ClientDetailHeaderReusableViewDelegate: class {
    func newReportButtonPressed()
}

class ClientDetailHeaderReusableView: UICollectionReusableView {
    
    weak var delegate: ClientDetailHeaderReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let lastTimeSV = UIStackView(arrangedSubviews: [lastVisitTitleLabel, lastVisitLabel])
        lastTimeSV.axis = .horizontal
        lastTimeSV.translatesAutoresizingMaskIntoConstraints = false
        lastTimeSV.spacing = 2
        lastTimeSV.distribution = .fill
        
        let firstRowSV = UIStackView(arrangedSubviews: [nameTitleLabel, lastTimeSV])
        firstRowSV.axis = .horizontal
        firstRowSV.translatesAutoresizingMaskIntoConstraints = false
        firstRowSV.distribution = .fillEqually
        firstRowSV.spacing = 2
        
        let fullNameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        fullNameSV.axis = .horizontal
        fullNameSV.translatesAutoresizingMaskIntoConstraints = false
        fullNameSV.distribution = .fillEqually
        fullNameSV.spacing = 2
        
        let nametitleSV = UIStackView(arrangedSubviews: [firstRowSV, fullNameSV])
        nametitleSV.axis = .vertical
        nametitleSV.translatesAutoresizingMaskIntoConstraints = false
        nametitleSV.spacing = 5
        
        let memoSV = UIStackView(arrangedSubviews: [memoTitleLabel, memoTextLabel])
        memoSV.axis = .vertical
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.spacing = 2
        
        let clientTopSV = UIStackView(arrangedSubviews: [clientImage, nametitleSV])
        clientTopSV.axis = .horizontal
        clientTopSV.translatesAutoresizingMaskIntoConstraints = false
        clientTopSV.spacing = 20
        clientTopSV.distribution = .fill
        
        addSubview(clientTopSV)
        clientTopSV.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        clientTopSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        clientTopSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        addSubview(memoSV)
        memoSV.topAnchor.constraint(equalTo: clientTopSV.bottomAnchor, constant: 10).isActive = true
        memoSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        memoSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        addSubview(addReportButton)
        addReportButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        addReportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        addReportButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    @objc func addButtonPressed() {
        self.delegate?.newReportButtonPressed()
    }

    
    var clientImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "beautiful-blur-blurred-background-733872"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 45
        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    let nameTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
//        lb.backgroundColor = .red
        return lb
    }()
    
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "FirstName"
        lb.translatesAutoresizingMaskIntoConstraints = false
//        lb.backgroundColor = .red
        return lb
    }()
    
    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LastName"
        lb.translatesAutoresizingMaskIntoConstraints = false
//        lb.backgroundColor = .red
        return lb
    }()
    
    let lastVisitTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LastTime:"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lb.font = UIFont.systemFont(ofSize: 12)
//        lb.backgroundColor = .red
        return lb
    }()
    
    let lastVisitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/12"
        lb.translatesAutoresizingMaskIntoConstraints = false
//        lb.backgroundColor = .red
        lb.font = UIFont.italicSystemFont(ofSize: 12)
        return lb
    }()
    
    let memoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
//        lb.backgroundColor = .red
        return lb
    }()
    
    let memoTextLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = """
        hello
        hello goodmorning
        it's me! Mario!
        """
        lb.numberOfLines = 0
        lb.sizeToFit()
        var labelframe = lb.frame
        lb.frame.origin.x = 0
        lb.frame.origin.y = labelframe.origin.y + labelframe.size.height
//        lb.backgroundColor = .yellow
        return lb
    }()
    
    let addReportButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("New Report", for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        bt.setTitleColor(.black, for: .normal)
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 10
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        bt.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        bt.layer.borderColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1).cgColor
        bt.setImage(UIImage(named: "addicon1"), for: .normal)
        return bt
    }()
}




