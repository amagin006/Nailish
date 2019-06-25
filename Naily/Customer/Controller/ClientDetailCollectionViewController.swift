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
//        fetchReportItem()
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
            try fetchedReportItemResultsController.performFetch()
        } catch let err {
            print(err)
        }

    }
    
    @objc func editButtonPressed() {
        let editVC = AddClientViewController()
        let editNVC = LightStatusNavigationController(rootViewController: editVC)
        editVC.delegate = self
        editVC.client = client
        present(editNVC, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = newfetchedReportItemResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    lazy var newfetchedReportItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ReportItem> in
        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
        let visitDateDescriptors = NSSortDescriptor(key: "visitDate", ascending: true)
        fetchRequest.sortDescriptors = [visitDateDescriptors]
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportImageCollectionViewCell
//        reportCell.reportItem = reportItems[indexPath.row]
        let reportData = newfetchedReportItemResultsController.object(at: indexPath)
        print("=+++++========\(reportData)")
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
        return .init(width: view.frame.width, height: 300)
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    
//    private func fetchReportItem() {
//        let managerContext = CoreDataManager.shared.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
//        fetchRequest.predicate = NSPredicate(format: "client == %@", client)
//        fetchRequest.sortDescriptors = []
//        do {
//            let reports = try managerContext.fetch(fetchRequest)
//            self.reportItems = reports
//        } catch let err {
//            print("Failed to fetch ClientList: \(err)")
//        }
//
//    }
}

extension ClientDetailCollectionViewController: ClientDetailHeaderReusableViewDelegate, NewReportViewControllerDelegate, AddClientViewControllerDelegate {
    
    func editClientDidFinish(client: ClientInfo) {
        self.client = client
    }
    
    func addClientDidFinish(client: ClientInfo) {
        
    }

    func reportSavedPressed(report: ReportItem) {
//        self.reportItems.append(report)
//        self.collectionView.insertItems(at: [IndexPath(item: self.reportItems.count - 1, section: 0)])
//        self.collectionView.reloadItems(at: [IndexPath(item: self.reportItems.count - 1, section: 0)])
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
