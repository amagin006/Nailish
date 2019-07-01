//
//  CalendarTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-27.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    var appointment: Appointment! {
        didSet {
            firstNameLabel.text = appointment.client!.firstName ?? ""
            lastNameLabel.text = appointment.client!.lastName ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            if let startTime = appointment.start {
                startTimeLabel.text = formatter.string(from: startTime)
            }
            if let endTime = appointment.end {
                endTimeLabel.text = formatter.string(from: endTime)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.addSubview(backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupUI() {
        
        let timeSV = UIStackView(arrangedSubviews: [startTimeLabel, separatorTimeLabel, endTimeLabel])
        timeSV.translatesAutoresizingMaskIntoConstraints = false
        timeSV.spacing = 5
        timeSV.axis = .horizontal
        
        firstNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let nameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        nameSV.translatesAutoresizingMaskIntoConstraints = false
        nameSV.axis = .horizontal
        nameSV.spacing = 10

        let textSV = UIStackView(arrangedSubviews: [nameSV, timeSV])
        textSV.translatesAutoresizingMaskIntoConstraints = false
        textSV.alignment = .leading
        textSV.distribution = .fill
        textSV.spacing = 2
        textSV.axis = .vertical

        let imageTextSV = UIStackView(arrangedSubviews: [clientImage, textSV])
        addSubview(imageTextSV)
        imageTextSV.translatesAutoresizingMaskIntoConstraints = false
        imageTextSV.axis = .horizontal
        imageTextSV.alignment = .center
        imageTextSV.spacing = 16
        imageTextSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imageTextSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        imageTextSV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     }
    
    private let clientImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "woman4"))
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Ashry"
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = " Henderson"
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let startTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "12:00"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .gray
        return lb
    }()
    
    private let separatorTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "~"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .gray
        return lb
    }()
    
    private let endTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "14:00"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .gray
        return lb
    }()
    
    private let memuLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Off + Jal + Design"
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()

}
