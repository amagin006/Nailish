//
//  ClientDetailCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

private let headerIdentifier = "ClientDetailheaderCell"
private let reportIdentifier = "ClientDetailReportCell"

class ClientDetailCollectionViewController: FetchCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var client: ClientInfo!
    var reportItems: [ReportItem]!
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        self.collectionView.register(ClientDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView.register(ReportImageCollectionViewCell.self, forCellWithReuseIdentifier: reportIdentifier)
        
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
        let reportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportImageCollectionViewCell
        let reportData = fetchedReportItemResultsController.object(at: indexPath)
        reportCell.delegate = self
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
    
    // MARK: UICollectionView flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let emptyLabel = UILabel(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        emptyLabel.numberOfLines = 0
        emptyLabel.lineBreakMode = .byWordWrapping
        // font
        emptyLabel.text = client.memo
        emptyLabel.sizeToFit()

        return .init(width: view.frame.width, height: emptyLabel.frame.height + 206)
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
}

extension ClientDetailCollectionViewController: ClientDetailHeaderReusableViewDelegate, ReportImageCollectionViewCellDelegate, AddClientViewControllerDelegate {

    func editClientDidFinish(client: ClientInfo) {
        self.client = client
    }
    
    func addClientDidFinish(client: ClientInfo) {
        
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
    
    
}
