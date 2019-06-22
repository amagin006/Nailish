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
//    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReportItem()
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
        navigationItem.rightBarButtonItem = editButton

    }

    
    @objc func editButtonPressed() {
        let editVC = AddClientViewController()
        editVC.delegate = self
        let editNVC = LightStatusNavigationController(rootViewController: editVC)
        editVC.client = client
        present(editNVC, animated: true, completion: nil)
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportImageCollectionViewCell
        reportCell.reportItem = reportItems[indexPath.row]
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
        fetchRequest.predicate = NSPredicate(format: "client == %@", client)
        fetchRequest.sortDescriptors = []
        do {
            let reports = try managerContext.fetch(fetchRequest)
            self.reportItems = reports
        } catch let err {
            print("Failed to fetch ClientList: \(err)")
        }
        
//        NSFetchedResultsController(fetchRequest: <#T##NSFetchRequest<_>#>, managedObjectContext: <#T##NSManagedObjectContext#>, sectionNameKeyPath: <#T##String?#>, cacheName: <#T##String?#>)
//        
//        
    }
    
    
}

extension ClientDetailCollectionViewController: AddClientViewControllerDelegate, ClientDetailHeaderReusableViewDelegate, NewReportViewControllerDelegate {

    func reportSavedPressed(report: ReportItem) {
        self.reportItems.append(report)
        self.collectionView.insertItems(at: [IndexPath(item: self.reportItems.count - 1, section: 0)])
        self.collectionView.reloadItems(at: [IndexPath(item: self.reportItems.count - 1, section: 0)])
    }

    // AddClientViewControllerDelegate
    func addClientDidFinish(client: ClientInfo) {
        
    }
    
    func editClientDidFinish(client: ClientInfo) {
        self.client = client
        self.collectionView.reloadData()
    }
    
    // ClientDetailHeaderReusableViewDelegate
    func newReportButtonPressed() {
        let newReportVC = NewReportViewController()
        newReportVC.client = client
        newReportVC.delegate = self
        let newReportNVC = LightStatusNavigationController(rootViewController: newReportVC)
        present(newReportNVC, animated: true, completion: nil)
    }
    
}
