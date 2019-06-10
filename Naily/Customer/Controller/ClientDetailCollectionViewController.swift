//
//  ClientDetailCollectionViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

private let headerIdentifier = "ClientDetailheaderCell"
private let reportIdentifier = "ClientDetailReportCell"

class ClientDetailCollectionViewController: BaseCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Register cell classes
        self.collectionView.register(ClientDetailHeadCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

        self.collectionView.register(ReportImageCollectionViewCell.self, forCellWithReuseIdentifier: reportIdentifier)
        
    }

    
    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reportIdentifier, for: indexPath) as! ReportImageCollectionViewCell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath)
        
        return headerView
    }
    

}
