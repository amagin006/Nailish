//
//  ReportImageCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class ReportImageCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "nailsample1"))
        return iv
    }()
    
}
