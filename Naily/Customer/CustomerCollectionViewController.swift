//
//  CustomerCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-05-30.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerId = "headerId"

class CustomerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var nameSortedClientList = [[ClientItem]]()
    var nameInitial = [String]()

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
        nameSort(clientItem: clientItems)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return nameInitial.count
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
        return CGSize(width: view.frame.width, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SectionHeader
            header.headerLable.text = "\(nameInitial[indexPath.section])"
            return header
        }
        fatalError()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    private var clientItems = [
        ClientItem(image: #imageLiteral(resourceName: "attractive-beautiful-beauty-1024311"), clientName: "Mery Jane", lastVisitDate: "2019/05/20"),
        ClientItem(image: #imageLiteral(resourceName: "woman1"), clientName: "Jaydon Rita", lastVisitDate: "2019/05/01"),
        ClientItem(image: #imageLiteral(resourceName: "beautiful-blur-blurred-background-733872"), clientName: "Love Orla", lastVisitDate: "2019/05/20"),
        ClientItem(image: #imageLiteral(resourceName: "woman10"), clientName: "Leonelle Madeleine", lastVisitDate: "2019/03/20"),
        ClientItem(image: #imageLiteral(resourceName: "woman9"), clientName: "Arlo Harmony", lastVisitDate: "2019/04/20"),
        ClientItem(image: #imageLiteral(resourceName: "woman3"), clientName: "Charley Danielle", lastVisitDate: "2019/04/26"),
        ClientItem(image: #imageLiteral(resourceName: "woman7"), clientName: "Meridith Philippa", lastVisitDate: "2019/03/21"),
        ClientItem(image: #imageLiteral(resourceName: "woman6"), clientName: "Roseann Yasmin", lastVisitDate: "2019/05/03"),
        ClientItem(image: #imageLiteral(resourceName: "woman5"), clientName: "Janice Nettie", lastVisitDate: "2019/05/10"),
        ClientItem(image: #imageLiteral(resourceName: "woman12"), clientName: "Egbertine Victoria", lastVisitDate: "2019/04/29"),
        ClientItem(image: #imageLiteral(resourceName: "woman11"), clientName: "Lamar Gemma", lastVisitDate: "2019/04/05"),
        ClientItem(image: #imageLiteral(resourceName: "woman4"), clientName: "Elodie Amirah", lastVisitDate: "2019/01/08"),
        ClientItem(image: #imageLiteral(resourceName: "woman8"), clientName: "Catherina Liberty", lastVisitDate: "2018/11/20"),
        ClientItem(image: #imageLiteral(resourceName: "woman13"), clientName: "Finley Kaitlin", lastVisitDate: "2019/02/14"),
    ]
    
    func nameSort(clientItem: [ClientItem]) {
        let nameSorted = clientItems.sorted(by: { ($0.clientName) < ($1.clientName) })
        for client in nameSorted {
            if nameInitial.count == 0 ||
                nameInitial.last != String(client.clientName.prefix(1)) {
                nameInitial.append(String(client.clientName.prefix(1)))
                nameSortedClientList.append([ClientItem]())
            }
            nameSortedClientList[nameInitial.count - 1].append(client)
        }
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
        headerLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
