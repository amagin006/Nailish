//
//  CalendarTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-27.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.addSubview(backView)
    }
    
    override func layoutSubviews() {
//        contentView.backgroundColor = .clear
//        backgroundColor = .clear
//        backView.layer.cornerRadius = 10
//        backView.clipsToBounds = true
    }
    
//    lazy var backView: UIView = {
//        let bv = UIView(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 100))
//        bv.backgroundColor = UIColor.blue
//        return bv
//    }()
    
    private let clientImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "woman4"))
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Ashry Henderson"
        lb.backgroundColor = .yellow
        return lb
    }()
    
    private let startTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "12:00"
        lb.backgroundColor = .lightGray
        return lb
    }()
    
    private let separatorTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "~"
        lb.backgroundColor = .lightGray
        return lb
    }()
    
    private let endTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "14:00"
        lb.backgroundColor = .lightGray
        return lb
    }()
    
    private let memuLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Off + Jal + Design"
        lb.backgroundColor = .lightGray
        return lb
    }()

}
