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
    func openEmail(address: String)
}

class ClientDetailHeaderReusableView: UICollectionReusableView {
    
    weak var delegate: ClientDetailHeaderReusableViewDelegate?
    
    var client: ClientInfo! {
        didSet {
            firstNameLabel.text = client.firstName!
            lastNameLabel.text = client.lastName ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            if client.mobileNumber != "" && client.mobileNumber != nil {
                phoneButton.isEnabled = true
            }
            if client.mailAdress != "" && client.mailAdress != nil {
                mailButton.isEnabled = true
            }
            if client.instagram != "" && client.instagram != nil {
                instagramButton.isEnabled = true
            }
            if client.twitter != "" && client.twitter != nil {
                twitterButton.isEnabled = true
            }
            if let dob = client.dateOfBirth {
                DOBLabel.text = formatter.string(from: dob)
            }
            memoTextLabel.text = client.memo ?? ""
            if let image = client.clientImage {
                clientImage.image = UIImage(data: image)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        setupUI()
    }
    
    func getHaderHeight() -> Int {
        return Int(self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(headerInfoBackView)
        headerInfoBackView.layer.cornerRadius = 10
        headerInfoBackView.layer.shadowColor = UIColor.black.cgColor
        headerInfoBackView.layer.shadowRadius = 8
        headerInfoBackView.layer.shadowOpacity = 0.1
        headerInfoBackView.layer.shadowOffset = CGSize.zero
        
        headerInfoBackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        headerInfoBackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        headerInfoBackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerInfoBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        
        addSubview(clientImage)
        clientImage.topAnchor.constraint(equalTo: headerInfoBackView.topAnchor, constant: -60).isActive = true
        clientImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let fullNameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        fullNameSV.translatesAutoresizingMaskIntoConstraints = false
        fullNameSV.axis = .horizontal
        fullNameSV.distribution = .fillEqually
        fullNameSV.spacing = 10
        
        addSubview(fullNameSV)
        fullNameSV.topAnchor.constraint(equalTo: clientImage.bottomAnchor, constant: 20).isActive = true
        fullNameSV.widthAnchor.constraint(equalTo: headerInfoBackView.widthAnchor, multiplier: 0.9).isActive = true
        fullNameSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        let dobSV = UIStackView(arrangedSubviews: [DOBImageView, DOBLabel])
        dobSV.translatesAutoresizingMaskIntoConstraints = false
        dobSV.axis = .horizontal
        dobSV.spacing = 20

        addSubview(dobSV)
        dobSV.topAnchor.constraint(equalTo: fullNameSV.bottomAnchor, constant: 15).isActive = true
        dobSV.widthAnchor.constraint(equalTo: headerInfoBackView.widthAnchor, multiplier: 0.4).isActive = true
        dobSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let contactButtonSV = UIStackView(arrangedSubviews: [phoneButton, mailButton, instagramButton, twitterButton])
        contactButtonSV.translatesAutoresizingMaskIntoConstraints = false
        contactButtonSV.axis = .horizontal
        contactButtonSV.distribution = .equalSpacing
        contactButtonSV.widthAnchor.constraint(equalToConstant: 180).isActive = true

        addSubview(contactButtonSV)
        contactButtonSV.widthAnchor.constraint(equalToConstant: 180).isActive = true
        contactButtonSV.topAnchor.constraint(equalTo: dobSV.bottomAnchor, constant: 16).isActive = true
        contactButtonSV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        addSubview(memoTextLabel)
        memoTextLabel.topAnchor.constraint(equalTo: contactButtonSV.bottomAnchor, constant: 16).isActive = true
        memoTextLabel.widthAnchor.constraint(equalTo: headerInfoBackView.widthAnchor, multiplier: 0.6).isActive = true
        memoTextLabel.centerXAnchor.constraint(equalTo: headerInfoBackView.centerXAnchor).isActive = true

        addSubview(newReportButton)
        newReportButton.topAnchor.constraint(equalTo: memoTextLabel.bottomAnchor, constant: 20).isActive = true
        newReportButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        newReportButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        newReportButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @objc func newReportButtonPressed() {
        self.delegate?.newReportButtonPressed()
    }
    
    enum ContactType: Int {
        case instagram = 1
        case twitter
        case facebook
        case line
        case email
        case mobile
    }
    
    @objc func tapContact(_ sender: UIButton) {
        switch sender.tag {
        case ContactType.instagram.rawValue:
            if client.instagram != "" {
                let account = client.instagram!
                let url = URL(string: "instagram://user?username=\(account)")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let instagramUrl = URL(string: "https://www.instagram.com/\(account)")
                    self.delegate?.snsTappedWebView(url: instagramUrl!)
                }
            }
        case ContactType.twitter.rawValue:
            if client.twitter != "" {
                let account = client.twitter!
                let url = URL(string: "twitter://user?screen_name=\(account)")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let twitterUrl = URL(string: "https://twitter.com/\(account)")
                    self.delegate?.snsTappedWebView(url: twitterUrl!)
                }
            }
        case ContactType.facebook.rawValue:
            print("facebook")
        case ContactType.line.rawValue:
            print("line")
        case ContactType.email.rawValue:
            print("email")
            if client.mailAdress != "" {
                let address = client.mailAdress!
                self.delegate?.openEmail(address: address)
            }

        case ContactType.mobile.rawValue:
            if client.mobileNumber != "" {
                let number = client.mobileNumber!
                let url = NSURL(string: "tel://\(number)")!
                UIApplication.shared.open(url as URL)
            }
        default:
            print("")
        }
    }
    
    // UIParts
    let headerInfoBackView: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .white
        return vi
    }()
    
    var clientImage: UIImageView = {
        let iv = UIImageView()
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
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "FirstName"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textAlignment = .right
        return lb
    }()

    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "LastName"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textAlignment = .left
        return lb
    }()
    
    let phoneButton: UIButton = {
        let bt = UIButton()
        let btnImage = #imageLiteral(resourceName: "tel2")
        bt.tag = 6
        bt.addTarget(self, action: #selector(tapContact(_:)), for: .touchUpInside)
        bt.setImage(btnImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt.isEnabled = false
        return bt
    }()
    
    let mailButton: UIButton = {
        let bt = UIButton()
        let btnImage = #imageLiteral(resourceName: "mail4")
        bt.tag = 5
        bt.addTarget(self, action: #selector(tapContact(_:)), for: .touchUpInside)
        bt.setImage(btnImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt.isEnabled = false
        return bt
    }()
    
    let instagramButton: UIButton = {
        let bt = UIButton()
        let btnImage = #imageLiteral(resourceName: "instagram2")
        bt.tag = 1
        bt.addTarget(self, action: #selector(tapContact(_:)), for: .touchUpInside)
        bt.setImage(btnImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt.isEnabled = false
        return bt
    }()
    
    let twitterButton: UIButton = {
        let bt = UIButton()
        let btnImage = #imageLiteral(resourceName: "twitter")
        bt.tag = 2
        bt.addTarget(self, action: #selector(tapContact(_:)), for: .touchUpInside)
        bt.setImage(btnImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt.isEnabled = false
        return bt
    }()
    
    let newReportButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor.init(red: 58/255, green: 158/255, blue: 85/255, alpha: 1)
        bt.setTitle("NEW REPORT", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(newReportButtonPressed), for: .touchUpInside)
        bt.setBackgroundColor(UIColor.init(red: 58/255, green: 158/255, blue: 85/255, alpha: 1), for: .normal)
        bt.setBackgroundColor(UIColor.init(red: 14/255, green: 57/255, blue: 26/255, alpha: 1), for: .selected)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        let plusImage = #imageLiteral(resourceName: "plus")
        bt.setImage(plusImage.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: plusImage.size.width / 2)
        bt.contentHorizontalAlignment = .center
        return bt
    }()
    
    let DOBImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "birthday"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()

    let DOBLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1900/01/01"
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let memoTextLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.sizeToFit()
        var labelframe = lb.frame
        lb.frame.origin.x = 0
        lb.frame.origin.y = labelframe.origin.y + labelframe.size.height
        return lb
    }()

}
