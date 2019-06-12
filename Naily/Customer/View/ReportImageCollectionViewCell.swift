//
//  ReportImageCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class ReportImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    let dataSouce = ["nailsample1", "nailsample2", "nailsample3"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        // constraints priority
        contentView.backgroundColor = .lightGray
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setDateHeader()
        setScrollingImageView()
        setPageControl()
        setDiscription()
        
        // dynamic cell (size)
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    func setDateHeader() {
        contentView.addSubview(dateLabel)
        dateLabel.anchors(topAnchor: contentView.topAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    func setScrollingImageView() {
        contentView.addSubview(scrollImageView)
        scrollImageView.delegate = self
        scrollImageView.anchors(topAnchor: dateLabel.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        scrollImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.layoutIfNeeded() // calculates sizes based on constraints
        
        scrollImageView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 20) * CGFloat(dataSouce.count), height: scrollImageView.bounds.height)
        scrollImageView.isUserInteractionEnabled = true
        scrollImageView.isPagingEnabled = true
        scrollImageView.showsHorizontalScrollIndicator = false
        scrollImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        addImageToScrollView(images: dataSouce)
    }
    
    func setPageControl() {
        contentView.addSubview(pageControl)
        pageControl.numberOfPages = dataSouce.count
        pageControl.defersCurrentPageDisplay = true
        pageControl.anchors(topAnchor: scrollImageView.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil)
    }
    
    
    func setDiscription() {
        let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuTextLabel, priceText, memoTitleLabel, memoTextLabel])
        contentView.addSubview(menuSV)
        menuSV.axis = .vertical
        menuSV.distribution = .equalSpacing
        menuSV.spacing = 1
        menuSV.anchors(topAnchor: pageControl.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, padding: .init(top: 0, left: 10, bottom: 20, right: 10))
        
    }
    

    func addImageToScrollView(images: [String]) {

        let width = UIScreen.main.bounds.width - 20
        let height = scrollImageView.bounds.height

        for i in 0..<images.count {
            let iv = UIImageView(frame: CGRect.init(x: 0 + width * CGFloat(i), y: 0, width: width, height: height))
            iv.image = UIImage(named: images[i])
            iv.isUserInteractionEnabled = true
            scrollImageView.addSubview(iv)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func updateCurrentPageDisplay() {
        print(pageControl.currentPage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // View
    let scrollImageView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let pageControl: UIPageControl = {
        let pg = UIPageControl()
        pg.translatesAutoresizingMaskIntoConstraints = false
        pg.pageIndicatorTintColor = .white
        pg.currentPageIndicatorTintColor = .black
        return pg
    }()
    
    let pagenation: UIPageControl = {
        let pc = UIPageControl()
        return pc
    }()
    
    // id date labels
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/10"
        return lb
    }()
    
    let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        lb.backgroundColor = .yellow
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let menuTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "off + Jal Nail + design"
        lb.backgroundColor = .red
        return lb
    }()
    
    let memoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        
        lb.backgroundColor = .yellow
        return lb
    }()
    
    let memoTextLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.backgroundColor = .red
        lb.text = """
        Description
        Description
        Description
        Description
        Description
        Description
        Description
        Description
        """
        return lb
    }()
    
    let priceText: UILabel = {
        let lb = UILabel()
        lb.text = "$ 60.00"
        lb.backgroundColor = .orange
        return lb
    }()
    
}

