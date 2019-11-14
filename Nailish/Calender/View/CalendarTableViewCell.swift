//
//  CalendarTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-27.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    var appointmentReport: ReportItem! {
        didSet {
            if let image = appointmentReport.client!.clientImage {
                clientImage.image = UIImage(data: image)
            }
            firstNameLabel.text = appointmentReport.client!.firstName ?? ""
            lastNameLabel.text = appointmentReport.client!.lastName ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            if let startTime = appointmentReport.startTime {
                startTimeLabel.text = formatter.string(from: startTime)
            } else {
                startTimeLabel.text = "00:00"
            }
            if let endTime = appointmentReport.endTime {
                endTimeLabel.text = formatter.string(from: endTime)
            } else {
                endTimeLabel.text = "00:00"
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
        self.addSubview(backView)
        backView.addBorders(edges: .bottom, color: UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1), width: 1)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
      super.setHighlighted(highlighted, animated: animated)
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
      self.selectedBackgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let bv = UIView(frame: CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: 80))
        return bv
    }()

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
        let iv = UIImageView(image: #imageLiteral(resourceName: "person2"))
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
        lb.textColor = UIColor(named: "PrimaryText")
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = " Henderson"
        lb.textColor = UIColor(named: "PrimaryText")
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
