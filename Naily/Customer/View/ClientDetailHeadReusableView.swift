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
    
    var client: ClientInfo? {
        didSet {
            firstNameLabel.text = client?.firstName!
            lastNameLabel.text = client?.lastName ?? ""
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            memoTextLabel.text = client?.memo ?? ""
            if let image = client?.clientImage {
                clientImage.image = UIImage(data: image)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 253/255, green: 193/255, blue: 104/255, alpha: 1)
        setupUI()
    }
    
    func getHaderHeight() -> Int {
        return Int(self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(clientImage)
        clientImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        clientImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let fullNameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        fullNameSV.axis = .horizontal
        fullNameSV.translatesAutoresizingMaskIntoConstraints = false
        fullNameSV.distribution = .equalSpacing
        fullNameSV.spacing = 2
        
        addSubview(fullNameSV)
        fullNameSV.topAnchor.constraint(equalTo: clientImage.bottomAnchor, constant: 20).isActive = true
        fullNameSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        fullNameSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
//        let nametitleSV = UIStackView(arrangedSubviews: [nameTitleLabel, fullNameSV])
//        nametitleSV.axis = .vertical
//        nametitleSV.translatesAutoresizingMaskIntoConstraints = false
        instagramLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
        let instagramSV = UIStackView(arrangedSubviews: [instagramTitleLabel, instagramLabel])
        instagramSV.axis = .horizontal
        instagramSV.spacing = 10
        instagramSV.translatesAutoresizingMaskIntoConstraints = false

        twitterLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
        let twitterSV = UIStackView(arrangedSubviews: [twitterTitleLabel, twitterLabel])
        twitterSV.axis = .horizontal
        twitterSV.spacing = 10
        twitterSV.translatesAutoresizingMaskIntoConstraints = false
//
//        let clientInfoRight = UIStackView(arrangedSubviews: [nameTitleLabel, fullNameSV, instagramSV, twitterSV])
//        clientInfoRight.axis = .vertical
//        clientInfoRight.translatesAutoresizingMaskIntoConstraints = false
        
//        let clientTopSV = UIStackView(arrangedSubviews: [clientImage, clientInfoRight])
//        clientTopSV.axis = .horizontal
//        clientTopSV.translatesAutoresizingMaskIntoConstraints = false
//        clientTopSV.spacing = 20
//        clientTopSV.alignment = .top
//        clientTopSV.distribution = .fill
        
        let memoSV = UIStackView(arrangedSubviews: [memoTitleLabel, memoTextLabel])
        memoSV.axis = .vertical
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.spacing = 2
        
        let headerInfoSV = UIStackView(arrangedSubviews: [instagramSV, twitterSV, memoSV])
        addSubview(headerInfoSV)
        headerInfoSV.translatesAutoresizingMaskIntoConstraints = false
        headerInfoSV.axis = .vertical
        headerInfoSV.spacing = 10
        headerInfoSV.topAnchor.constraint(equalTo: fullNameSV.bottomAnchor, constant: 20).isActive = true
        headerInfoSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerInfoSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        addSubview(reportTitleView)
        reportTitleView.topAnchor.constraint(equalTo: headerInfoSV.bottomAnchor, constant: 10).isActive = true
        reportTitleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        reportTitleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        reportTitleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        reportTitleView.addSubview(addReportButton)
        addReportButton.centerYAnchor.constraint(equalTo: reportTitleView.centerYAnchor).isActive = true
        addReportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        addReportButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func addButtonPressed() {
        self.delegate?.newReportButtonPressed()
    }
    
    @objc func tapSNS(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 {
            print("instagram")
        } else if sender.view?.tag == 2 {
            print("twitter")
        }
    }
    
    // UIParts
    var clientImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "beautiful-blur-blurred-background-733872"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 60
        iv.widthAnchor.constraint(equalToConstant: 120).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 120).isActive = true
        iv.clipsToBounds = true
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .white
        return iv
    }()
    
    let nameTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "FirstName"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LastName"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    let lastVisitTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LastTime:"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    let lastVisitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/12"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.italicSystemFont(ofSize: 12)
        return lb
    }()
    
    let memoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    let instagramTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Instagram"
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let instagramLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel()
        lb.text = "instagram001"
        lb.tag = 1
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let twitterTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "twitter"
        lb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let twitterLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel   ()
        lb.text = "@twitter"
        lb.tag = 2
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()

    let memoTextLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.sizeToFit()
        var labelframe = lb.frame
        lb.frame.origin.x = 0
        lb.frame.origin.y = labelframe.origin.y + labelframe.size.height
        return lb
    }()
    
    let reportTitleView: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = UIColor(red: 236/255, green: 123/255, blue: 125/255, alpha: 1)
        return vi
    }()
    
    let addReportButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("New Report", for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        bt.setTitleColor(.black, for: .normal)
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 10
        bt.backgroundColor = .white
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        bt.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        bt.layer.borderColor = UIColor(cgColor: #colorLiteral(red: 0, green: 0.5433532596, blue: 0.7865155935, alpha: 1)).cgColor
        bt.setImage(UIImage(named: "addicon1"), for: .normal)
        return bt
    }()
}
