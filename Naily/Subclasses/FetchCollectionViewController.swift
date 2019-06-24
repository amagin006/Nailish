//
//  FetchCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-23.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

struct CollectionViewContentChange {
    let type: NSFetchedResultsChangeType
    let indexPath: IndexPath?
    let newIndexPath: IndexPath?
}

struct CollectionViewSectionChange {
    let type: NSFetchedResultsChangeType
    let sectionInfo: NSFetchedResultsSectionInfo
    let sectionIndex: Int
}


class FetchCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var contentsChanges = [CollectionViewContentChange]()
    var sectionChanges = [CollectionViewSectionChange]()
   
    override func viewDidLoad() {
        fetchedClientInfoResultsController.delegate = self
        fetchedReportItemResultsController.delegate = self
    }
    
    lazy var fetchedClientInfoResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ClientInfo> in
        let fetchRequest = NSFetchRequest<ClientInfo>(entityName: "ClientInfo")
        let nameInitialDescriptors = NSSortDescriptor(key: "nameInitial", ascending: true)
        let firstNameDescriptors = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [nameInitialDescriptors, firstNameDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "nameInitial",
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    lazy var fetchedReportItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ReportItem> in
        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
        let visitDateDescriptors = NSSortDescriptor(key: "visitDate", ascending: true)
        fetchRequest.sortDescriptors = [visitDateDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let change = CollectionViewContentChange(type: type, indexPath: indexPath, newIndexPath: newIndexPath)
        contentsChanges.append(change)
    }
    // FIRST TIME EDITTING NOT UPDATING
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let change = CollectionViewSectionChange(type: type, sectionInfo: sectionInfo, sectionIndex: sectionIndex)
        sectionChanges.append(change)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for contentsChange in contentsChanges {
                self.performCollectionViewContentsChange(contentsChange)
            }
            for sectionChange in sectionChanges {
                self.performCollectionViewSectionChange(sectionChange)
            }
        }, completion: { _ in
            self.contentsChanges.removeAll()
            self.sectionChanges.removeAll()
        })
    }
}

private extension FetchCollectionViewController {
    func performCollectionViewContentsChange(_ contentChange: CollectionViewContentChange) {
        
        switch contentChange.type {
        case .insert:
            collectionView.insertItems(at: [contentChange.newIndexPath!])
        case .update:
            collectionView.reloadItems(at: [contentChange.indexPath!])
        case .move:
            collectionView.deleteItems(at: [contentChange.indexPath!])
            collectionView.insertItems(at: [contentChange.newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [contentChange.indexPath!])
        @unknown default:
            fatalError()
        }
    }
    
    func performCollectionViewSectionChange(_ sectionChange: CollectionViewSectionChange) {
        
        switch sectionChange.type {
        case .insert:
            collectionView.insertSections(NSIndexSet(index: sectionChange.sectionIndex) as IndexSet)
        case .delete:
            collectionView.deleteSections(NSIndexSet(index: sectionChange.sectionIndex) as IndexSet)
        default: break
        }
    }
}
