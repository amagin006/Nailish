//
//  ReportCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-16.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class ReportCollectionViewCell: UICollectionViewCell {
    
    var reportItem: ReportItem! {
        didSet {
            if let image = reportItem.snapshot1 {
                nailImageView.image = UIImage(data: image)
            }
            let formatter = DateFormatter()
            if let date = reportItem.visitDate {
                formatter.dateFormat = "YYYY/MM/dd"
                lastVisitDate.text = formatter.string(from: date)
            }
            if let start = reportItem.startTime {
                formatter.dateFormat = "HH:mm"
                startTime.text = formatter.string(from: start)
            }
            if let end = reportItem.endTime {
                formatter.dateFormat = "HH:mm"
                endTime.text = formatter.string(from: end)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    func setupUI() {
        let timeSV = UIStackView(arrangedSubviews: [startTime, separatorTimeLabel, endTime])
        timeSV.spacing = 5
        timeSV.axis = .horizontal
        timeSV.distribution = .equalCentering
        
        lastVisitDate.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let dateTimeSV = UIStackView(arrangedSubviews: [lastVisitDate, timeSV])
        dateTimeSV.axis = .vertical
        dateTimeSV.alignment = .leading
        
        let reportSV = UIStackView(arrangedSubviews: [nailImageView, dateTimeSV])
        reportSV.axis = .horizontal
        reportSV.spacing = 20
        
        contentView.addSubview(reportSV)
        reportSV.translatesAutoresizingMaskIntoConstraints = false
        reportSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        reportSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        reportSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        reportSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    //UI Parts
    let nailImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.constraintWidth(equalToConstant: 50)
        iv.constraintHeight(equalToConstant: 50)
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let lastVisitDate: UILabel = {
        let lb = UILabel()
        lb.text = "2019/07/01"
        return lb
    }()
    
    let startTime: UILabel = {
        let lb = UILabel()
        lb.text = "12:00"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.init(red: 156/255, green: 166/255, blue: 181/255, alpha: 1)
        return lb
    }()
    
    let separatorTimeLabel: UILabel = {
        let lb = UILabel()
        lb.text = " ~ "
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.init(red: 156/255, green: 166/255, blue: 181/255, alpha: 1)
        return lb
    }()
    
    let endTime: UILabel = {
        let lb = UILabel()
        lb.text = "14:00"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.init(red: 156/255, green: 166/255, blue: 181/255, alpha: 1)
        return lb
    }()
    
    
}
