//
//  ReportImageCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class ReportImageCollectionViewCell: UICollectionViewCell {
    
    let dataSouce = ["nailsample1", "nailsample2", "nailsample3"]
    
    let scrollImageView: UIScrollView = {
        let sv = UIScrollView()
        
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollImageView)
        scrollImageView.matchParent()
        scrollImageView.contentSize = CGSize(width: contentView.frame.width * CGFloat(dataSouce.count), height: contentView.frame.height)
        scrollImageView.isUserInteractionEnabled = true
        scrollImageView.isPagingEnabled = true
        addImageToScrollView(images: dataSouce)
    }
    
    // TODO: find a way to scroll inside scrollview inside collectionView
    func addImageToScrollView(images: [String]) {
        let width = contentView.frame.width
        let height = contentView.frame.height
        for i in 0..<images.count {
            let iv = UIImageView(frame: CGRect.init(x: 0 + width * CGFloat(i), y: 0, width: width, height: height))
            iv.image = UIImage(named: images[i])
            iv.isUserInteractionEnabled = true
            scrollImageView.addSubview(iv)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // id date labels
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/10"
        return lb
    }()
    
    
    // additional data
    let headImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "nailsample1"))
        return iv
    }()
    
}
