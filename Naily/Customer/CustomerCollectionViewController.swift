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

class CustomerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddClientViewControllerDelegate {
    
    
    let cellId = "cellId"
    var clientList = [ClientItem]()
    var nameSortedClientList = [[ClientItem]]()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        // sticky header
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(CustomerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        setRightAddButton()
        fetchClient()
        nameSort(clientList: clientList)
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
    
    private func fetchClient() {
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ClientItem>(entityName: "ClientItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        do {
            let clients = try manageContext.fetch(fetchRequest)
            self.clientList = clients
            self.collectionView.reloadData()
        } catch let err {
            print("Failed to fetch ClientList: \(err)")
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return nameSortedClientList.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return nameSortedClientList[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomerCollectionViewCell
        
        // sorted by name
        cell.clientItem = nameSortedClientList[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SectionHeader
            let firstItem = nameSortedClientList[indexPath.section][indexPath.item].firstName!
            if let firstChar = firstItem.first {
                header.headerLable.text = "\(firstChar)"
            }
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
        print("pressed cell \(indexPath)")

        let detailVC = ClientDetailCollectionViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)


//        // Delete Item
//        let deletClient = nameSortedClientList[indexPath.section][indexPath.row]
//        nameSortedClientList[indexPath.section].remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//
//        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
//        manageContext.delete(deletClient)
//        CoreDataManager.shared.persistentContainer.viewContext.delete(deletClient)
//        CoreDataManager.shared.saveContext()

    }
    
    func addClientDidFinish(client: ClientItem) {
        clientList.append(client)
        nameSort(clientList: clientList)
        collectionView.reloadData()
    }

    func editClientDidFinish(client: ClientItem) {
        print(client)
    }

    func nameSort(clientList: [ClientItem]) {
        let nameSorted = clientList.sorted(by: { ($0.firstName!) < ($1.firstName!) })
        
        let groupedNames = nameSorted.reduce([[ClientItem]]()) {
            guard var last = $0.last else { return [[$1]] }
            var collection = $0
            if last.first!.firstName!.first == $1.firstName!.first {
                last += [$1]
                collection[collection.count - 1] = last
            } else {
                collection += [[$1]]
            }
            return collection
        }
        self.nameSortedClientList = groupedNames
    }
    
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
