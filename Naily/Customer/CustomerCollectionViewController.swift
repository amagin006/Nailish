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
private let cellId = "cellId"

protocol CustomerCollectionViewControllerDelegate: class {
    func selectedClient(client: ClientInfo)
}

class CustomerCollectionViewController: FetchCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectClient = false
    weak var delegate: CustomerCollectionViewControllerDelegate?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchClient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClient()

        self.collectionView!.register(CustomerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        setRightAddButton()
        
    }
    
    func fetchClient() {
        do {
            try fetchedClientInfoResultsController.performFetch()
        } catch let err {
            print("can't fetch clientInfo - \(err)")
        }
    }

    // MARK: helper methods
    private func setRightAddButton() {
        let iconButton = UIButton(type: .custom)
        let image = UIImage(named: "add-contact")?.withRenderingMode(.alwaysTemplate)
        iconButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        iconButton.setImage(image, for: .normal)
        iconButton.addTarget(self, action: #selector(navigateAddClient), for: .touchUpInside)
        
        let addButton = UIBarButtonItem(customView: iconButton)
        addButton.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func navigateAddClient() {
        let addVC = AddClientViewController()
        let addNVC = LightStatusNavigationController(rootViewController: addVC)
        present(addNVC, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let count = fetchedClientInfoResultsController.sections?.count {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedClientInfoResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomerCollectionViewCell
        
        let clientInfoData = fetchedClientInfoResultsController.object(at: indexPath)
        cell.clientInfo = clientInfoData

        do {
            fetchedReportItemResultsController.fetchRequest.predicate = NSPredicate(format: "client == %@", clientInfoData)
            try fetchedReportItemResultsController.performFetch()
        } catch let err {
            print("Failed fetchedReportItem \(err)")
        }
        let reports = fetchedReportItemResultsController.fetchedObjects!
        if !reports.isEmpty {
            cell.clientReport = reports[0]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SectionHeader
            
            let firstItem = fetchedClientInfoResultsController.sections![indexPath.section]
            header.headerLable.text = "\(firstItem.name.first!)"
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
        
        if selectClient {
            let selectedClient = fetchedClientInfoResultsController.object(at: indexPath)
            self.delegate?.selectedClient(client: selectedClient)
            self.navigationController?.popViewController(animated: true)
        } else {
            let detailVC = ClientDetailCollectionViewController()
            detailVC.client = fetchedClientInfoResultsController.object(at: indexPath)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

//        // Delete Item
//        let clientInfoData = fetchedClientInfoResultsController.object(at: indexPath)
//        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
//        manageContext.delete(clientInfoData)
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
