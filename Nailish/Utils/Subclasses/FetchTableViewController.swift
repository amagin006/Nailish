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
    
    var tableView: UITableView!

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
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            fatalError()
        }
    }
}
