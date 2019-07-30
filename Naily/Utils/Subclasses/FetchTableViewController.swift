//
//  FetchTableViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-27.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class FetchTableViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedReportItemResultsController.delegate = self
        fetchedSelectedMenuItemResultsController.delegate = self
    }
    
    lazy var fetchedReportItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ReportItem> in
        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
        let visitDateDescriptors = NSSortDescriptor(key: "visitDate", ascending: false)
        fetchRequest.sortDescriptors = [visitDateDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }()
    
    lazy var fetchedSelectedMenuItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<SelectedMenuItem> in
        let fetchRequest = NSFetchRequest<SelectedMenuItem>(entityName: "SelectedMenuItem")
        let menuItemDescriptors = NSSortDescriptor(key: "tag", ascending: true)
        fetchRequest.sortDescriptors = [menuItemDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()

    // FetchTableview Update
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        print("TableView.beginUpdates()")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print("TableView.endUpdates()")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("TableView.insert")
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            print("TableView.delete")
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            print("TableView.update")
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            print("TableView.move")
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            fatalError()
        }
    }
}
