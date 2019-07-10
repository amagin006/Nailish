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
    func snsTappedWebView(url: URL)
}

class ClientDetailHeaderReusableView: UICollectionReusableView {
    
    weak var delegate: ClientDetailHeaderReusableViewDelegate?
    
    var client: ClientInfo! {
        didSet {
            firstNameLabel.text = client.firstName!
            lastNameLabel.text = client.lastName ?? ""
            instagramLabel.text = client.instagram ?? ""
            twitterLabel.text = client.twitter ?? ""
//            facebookLabel.text = client.facebook ?? ""
//            lineLabel.text =  client.line ?? ""
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            memoTextLabel.text = client.memo ?? ""
            if let image = client.clientImage {
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
        
        instagramLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
        let instagramSV = UIStackView(arrangedSubviews: [instagramImageView, instagramTitleLabel, instagramLabel])
        instagramSV.axis = .horizontal
        instagramSV.spacing = 10
        instagramSV.translatesAutoresizingMaskIntoConstraints = false

        twitterLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
        let twitterSV = UIStackView(arrangedSubviews: [twitterImageView, twitterTitleLabel, twitterLabel])
        twitterSV.axis = .horizontal
        twitterSV.spacing = 10
        twitterSV.translatesAutoresizingMaskIntoConstraints = false
        
        let mailSV = UIStackView(arrangedSubviews: [mailTitleLabel, mailLabel])
        mailSV.axis = .horizontal
        mailSV.spacing = 10
        
        let mobileSV = UIStackView(arrangedSubviews: [mobileTitleLabel, mobileLabel])
        mobileSV.axis = .horizontal
        mobileSV.spacing = 10
        
        let dobSV = UIStackView(arrangedSubviews: [DOBTitleLabel, DOBLabel])
        dobSV.axis = .horizontal
        dobSV.spacing = 10
        
        
//        facebookLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
//        let facebookSV = UIStackView(arrangedSubviews: [facebookTitleLabel, facebookLabel])
//        facebookSV.axis = .horizontal
//        facebookSV.spacing = 10
//        facebookSV.translatesAutoresizingMaskIntoConstraints = false
//
//        lineLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSNS)))
//        let lineSV = UIStackView(arrangedSubviews: [lineTitleLabel, lineLabel])
//        lineSV.axis = .horizontal
//        lineSV.spacing = 10
//        lineSV.translatesAutoresizingMaskIntoConstraints = false
//
//        let snsSecondRow = UIStackView(arrangedSubviews: [facebookSV, lineSV])
//        snsSecondRow.axis = .horizontal
//        snsSecondRow.distribution = .fillEqually
        

        let memoSV = UIStackView(arrangedSubviews: [memoTitleLabel, memoTextLabel])
        memoSV.axis = .vertical
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.spacing = 6
        
        let headerInfoSV = UIStackView(arrangedSubviews: [instagramSV, twitterSV, mailSV, mobileSV, dobSV])
        addSubview(headerInfoSV)
        headerInfoSV.translatesAutoresizingMaskIntoConstraints = false
        headerInfoSV.axis = .vertical
        headerInfoSV.spacing = 10
        headerInfoSV.topAnchor.constraint(equalTo: fullNameSV.bottomAnchor, constant: 20).isActive = true
        headerInfoSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerInfoSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        addSubview(memoSV)
        memoSV.topAnchor.constraint(equalTo: headerInfoSV.bottomAnchor, constant: 20).isActive = true
        memoSV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        memoSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(reportTitleView)
        reportTitleView.topAnchor.constraint(equalTo: memoSV.bottomAnchor, constant: 10).isActive = true
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
            let account = instagramLabel.text!
            let url = URL(string: "instagram://user?username=\(account)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let instagramUrl = URL(string: "https://www.instagram.com/\(account)")
                self.delegate?.snsTappedWebView(url: instagramUrl!)
            }
        } else if sender.view?.tag == 2 {
            let account = twitterLabel.text!
            let url = URL(string: "twitter://user?id=\(account)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let twitterUrl = URL(string: "https://twitter.com/\(account)")
                self.delegate?.snsTappedWebView(url: twitterUrl!)
            }
        } else if sender.view?.tag == 3 {
//            let account = facebookLabel.text!
//            let url = URL(string: "fb://profile/\(account)")!
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                let twitterUrl = URL(string: "https://www.facebook.com/\(account)")
//                self.delegate?.snsTappedWebView(url: twitterUrl!)
//            }
        } else if sender.view?.tag == 4 {
//            let account = lineLabel.text!
//            let url = URL(string: "line://ti/p/\(account)")!
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                let twitterUrl = URL(string: "https://line.me/R/")
//                self.delegate?.snsTappedWebView(url: twitterUrl!)
//            }
        } else if sender.view?.tag == 5 {
            // Open mail app
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
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
    
    let instagramImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "instagram"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()

    let instagramTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Instagram:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
    
    let twitterImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "twitter"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let twitterTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Twitter:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let twitterLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel()
        lb.text = "@twitter"
        lb.tag = 2
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let facebookTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Facebook:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let facebookLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel()
        lb.text = "Facebook ID"
        lb.tag = 3
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let lineTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Line:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let lineLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel()
        lb.text = "Line ID"
        lb.tag = 4
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let mailTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Mail:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let mailLabel: UnderlineUILabel = {
        let lb = UnderlineUILabel()
        lb.text = "example@gmail.com"
        lb.tag = 5
        lb.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let mobileTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Mobile:"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let mobileLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0000000000"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()

    let DOBTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Date of Birth"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    let DOBLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1999/06/22"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()

    let memoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 12)
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
