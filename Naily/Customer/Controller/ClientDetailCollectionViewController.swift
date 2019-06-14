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

class ClientDetailCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

    
    var client: ClientInfo!
    var reportItems: [ReportItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

        // Register cell classes
        self.collectionView.register(ClientDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        self.collectionView.register(ReportImageCollectionViewCell.self, forCellWithReuseIdentifier: reportIdentifier)
        collectionView?.collectionViewLayout = layout
        self.title = "Client Report"
        
        let editButton: UIBarButtonItem = {
            let bb = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
            return bb
        }()
        navigationItem.rightBarButtonItem = editButto
//        fetchReportItem()
    }

    
    @objc func editButtonPressed() {
        print("press edit")
    }
    
    
    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportImageCollectionViewCell
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ClientDetailHeaderReusableView
        
        headerView.firstNameLabel.text = client.firstName!
        if let last = client.lastName {
            headerView.lastNameLabel.text = last
        }
        if let image = client.clientImage {
            headerView.clientImage.image = UIImage(data: image)
        }
        if let memo = client.memo {
            headerView.memoTextLabel.text = memo
        }
        return headerView
    }
    
    // MARK: UICollectionView flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    
    private func fetchReportItem() {
        let managerContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
        let id = client.objectID
        fetchRequest.predicate = NSPredicate(format: "client.objectID == %@", id)
//        fetchRequest.sortDescriptors = []
        
        do {
            let reports = try managerContext.fetch(fetchRequest)
            self.reportItems = reports
            
        } catch let err {
            print("Failed to fetch ClientList: \(err)")
        }
    }
    
    
}
