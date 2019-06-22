//
//  CustomerCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-05-30.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"
private let headerId = "headerId"

class CustomerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, AddClientViewControllerDelegate {
    
    
    let cellId = "cellId"
//    var clientList = [ClientInfo]()
//    var nameSortedClientList = [[ClientInfo]]()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
            print("hello")
        } catch let err {
            print(err)
        }
        self.collectionView!.register(CustomerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        setRightAddButton()
//        fetchClient()
//        nameSort(clientList: clientList)

    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ClientInfo> in
        let fetchRequest = NSFetchRequest<ClientInfo>(entityName: "ClientInfo")
        let nameInitialDescriptors = NSSortDescriptor(key: "nameInitial", ascending: true)
        let firstNameDescriptors = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [nameInitialDescriptors, firstNameDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "nameInitial", cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completed) in
            
        })
    }
    
    // MARK: helper methods
    private func setRightAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add-contact"), style: .plain, target: self, action: #selector(navigateAddClient))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func navigateAddClient() {
        let addVC = AddClientViewController()
        addVC.delegate = self 
        let addNVC = LightStatusNavigationController(rootViewController: addVC)
        present(addNVC, animated: true, completion: nil)
    }
    
//    private func fetchClient() {
//        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
//        let fetchRequestInfo = NSFetchRequest<ClientInfo>(entityName: "ClientInfo")
//        fetchRequestInfo.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
//
//        do {
//            let clients = try manageContext.fetch(fetchRequestInfo)
//            self.clientList = clients
//            self.collectionView.reloadData()
//        } catch let err {
//            print("Failed to fetch ClientList: \(err)")
//        }
//    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return nameSortedClientList[section].count
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomerCollectionViewCell
        
        // sorted by name
        let clientInfoData = fetchedResultsController.object(at: indexPath)
        cell.clientInfo = clientInfoData
        
//        cell.clientInfo = nameSortedClientList[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SectionHeader
//            let firstItem = nameSortedClientList[indexPath.section][indexPath.item].firstName!
            let firstItem = fetchedResultsController.sections![indexPath.section]
//            if let firstChar = firstItem {
                header.headerLable.text = "\(firstItem.name.first!)"
//            }
            return header
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = ClientDetailCollectionViewController()
        detailVC.client = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(detailVC, animated: true)

//        // Delete Ite
//        let deletClient = nameSortedClientList[indexPath.section][indexPath.row]
//        nameSortedClientList[indexPath.section].remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//
//        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
//        manageContext.delete(deletClient)
//        CoreDataManager.shared.persistentContainer.viewContext.delete(deletClient)
//        CoreDataManager.shared.saveContext()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func addClientDidFinish(client: ClientInfo) {
        print("addClient ")
//        clientList.append(client)
//        nameSort(clientList: clientList)
//        collectionView.reloadData()
    }

    func editClientDidFinish(client: ClientInfo) {
        print(client)
    }

//    func nameSort(clientList: [ClientInfo]) {
//        let nameSorted = clientList.sorted(by: { ($0.firstName!) < ($1.firstName!) })
//
//        let groupedNames = nameSorted.reduce([[ClientInfo]]()) {
//            guard var last = $0.last else { return [[$1]] }
//            var collection = $0
//            if last.first!.firstName!.first == $1.firstName!.first {
//                last += [$1]
//                collection[collection.count - 1] = last
//            } else {
//                collection += [[$1]]
//            }
//            return collection
//        }
//        self.nameSortedClientList = groupedNames
//    }
    
}



class SectionHeader: UICollectionReusableView {
    
    let headerLable: UILabel = {
        let lb = UILabel()
        lb.text = "section Title"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLable)
        backgroundColor = .white
        headerLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
