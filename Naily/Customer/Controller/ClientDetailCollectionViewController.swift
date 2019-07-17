//
//  ClientDetailCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData
import WebKit
import MessageUI

private let headerIdentifier = "ClientDetailheaderCell"
private let reportIdentifier = "ClientDetailReportCell"

class ClientDetailCollectionViewController: FetchCollectionViewController, UICollectionViewDelegateFlowLayout, WKUIDelegate {
    
    var client: ClientInfo!
    var reportItems: [ReportItem]!
    var webView: WKWebView!
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.collectionView.register(ClientDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.register(ReportCollectionViewCell.self, forCellWithReuseIdentifier: reportIdentifier)
        
        collectionView?.collectionViewLayout = layout
        self.title = "Client Report"
        let editButton: UIBarButtonItem = {
            let bb = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
            return bb
        }()

        navigationItem.rightBarButtonItem = editButton
        
        do {
            fetchedReportItemResultsController.fetchRequest.predicate = NSPredicate(format: "client == %@", client)
            try fetchedReportItemResultsController.performFetch()
        } catch let err {
            print("Failed fetchedReportItem \(err)")
        }
    }
    
    @objc private func editButtonPressed() {
        let editVC = AddClientViewController()
        let editNVC = LightStatusNavigationController(rootViewController: editVC)
        editVC.delegate = self
        editVC.client = client
        present(editNVC, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedReportItemResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportCollectionViewCell
        let reportData = fetchedReportItemResultsController.object(at: indexPath)
//        reportCell.delegate = self
        reportCell.reportItem = reportData

        return reportCell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ClientDetailHeaderReusableView
        headerView.delegate = self
        headerView.client = client
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reportItem = fetchedReportItemResultsController.object(at: indexPath)
        let reportDetailVC = ReportDetailViewController()
        reportDetailVC.report = reportItem
        self.navigationController?.pushViewController(reportDetailVC, animated: true)
    }
    
    // MARK: UICollectionView flow layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let emptyLabel = UILabel(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        emptyLabel.numberOfLines = 0
        emptyLabel.lineBreakMode = .byWordWrapping
        // font
        emptyLabel.text = client.memo
        emptyLabel.sizeToFit()

        return .init(width: view.frame.width, height: emptyLabel.frame.height + 400)
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 2
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    
}

extension ClientDetailCollectionViewController: ClientDetailHeaderReusableViewDelegate, ReportImageCollectionViewCellDelegate, AddClientViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func editClientDidFinish(client: ClientInfo) {
        self.client = client
    }
    
    func deleteClientButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // ClientDetailHeaderReusableViewDelegate
    func newReportButtonPressed() {
        let newReportVC = NewReportViewController()
        newReportVC.client = client
        let newReportNVC = LightStatusNavigationController(rootViewController: newReportVC)
        present(newReportNVC, animated: true, completion: nil)
    }
    
    // ClientDetailHeaderReusableViewDelegate
    func editReportItemButtonPressed(report: ReportItem) {
        let editReportVC = NewReportViewController()
        editReportVC.client = client
        editReportVC.report = report
        let editReportNVC = LightStatusNavigationController(rootViewController: editReportVC)
        present(editReportNVC, animated: true, completion: nil)
    }
    
    func snsTappedWebView(url: URL) {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

    func openEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            print("open mail")
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setMessageBody("", isHTML: false)
            self.present(mail, animated: true, completion: nil)
        } else {
            print("failed to open mail")
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

}
