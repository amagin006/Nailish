//
//  FetchTableViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-03.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class FetchTableViewController: UIViewController, UITableViewDelegate {

    lazy var fetchedAppointmentItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Appointment> in
        let fetchRequest = NSFetchRequest<Appointment>(entityName: "Appointment")
        let appointmentDateDescriptors = NSSortDescriptor(key: "appointmentDate", ascending: true)
        fetchRequest.sortDescriptors = [appointmentDateDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
}
