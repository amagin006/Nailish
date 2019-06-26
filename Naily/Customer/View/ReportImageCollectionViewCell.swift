//
//  ReportImageCollectionViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-09.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

protocol ReportImageCollectionViewCellDelegate: class {
    func editReportItemButtonPressed(report: ReportItem)
}

class ReportImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    weak var delegate: ReportImageCollectionViewCellDelegate?
    
    var snapshotImages = [Data]()
    var reportItem: ReportItem! {
        didSet {
            snapshotImages.removeAll()
            if let snapshot1 = reportItem.snapshot1 {
                snapshotImages.append(snapshot1)
            }
            if let snapshot2 = reportItem.snapshot2 {
                snapshotImages.append(snapshot2)
            }
            if let snapshot3 = reportItem.snapshot3 {
                snapshotImages.append(snapshot3)
            }
            if let snapshot4 = reportItem.snapshot4 {
                snapshotImages.append(snapshot4)
            }
            setupUI()
            dateLabel.text = reportItem.visitDate
            menuTextLabel.text = reportItem.menu
            memoTextLabel.text = reportItem.memo
            priceText.text = "\(reportItem.price)"
            tipsText.text = "\(reportItem.tips)"
            totalPriceText.text = "\(reportItem.price + reportItem.tips)"
        }
    }
    
    func setupUI() {
        setDateHeader()
        setScrollingImageView()
        setPageControl()
        setDescription()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 10/255, green: 20/255, blue: 15/255, alpha: 0.2)
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
        dateLabel.anchors(topAnchor: contentView.topAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
    }
    
    func setScrollingImageView() {
        contentView.addSubview(scrollImageView)
        scrollImageView.delegate = self
        scrollImageView.anchors(topAnchor: dateLabel.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 10))
        scrollImageView.heightAnchor.constraint(equalToConstant: 396).isActive = true
        contentView.layoutIfNeeded() // calculates sizes based on constraints
        
        scrollImageView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 20) * CGFloat(snapshotImages.count), height: scrollImageView.bounds.height)
        scrollImageView.isUserInteractionEnabled = true
        scrollImageView.isPagingEnabled = true
        scrollImageView.showsHorizontalScrollIndicator = false
        scrollImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        addImageToScrollView(images: snapshotImages)
    }
    
    func addImageToScrollView(images: [Data]) {
        let width = UIScreen.main.bounds.width - 20
        let height = scrollImageView.bounds.height
        
        for i in 0..<images.count {
            let iv = UIImageView(frame: CGRect.init(x: 0 + width * CGFloat(i), y: 0, width: width, height: height))
            iv.image = UIImage(data: images[i])
            iv.isUserInteractionEnabled = true
            scrollImageView.addSubview(iv)
        }
    }
    
    func setPageControl() {
        contentView.addSubview(pageControl)
        pageControl.defersCurrentPageDisplay = true
        pageControl.numberOfPages = snapshotImages.count
        pageControl.anchors(topAnchor: scrollImageView.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil)
    }
    
    func setDescription() {
        let priceSV = UIStackView(arrangedSubviews: [priceTitleLabel, priceText])
        priceSV.axis = .vertical
        let tipsSV = UIStackView(arrangedSubviews: [tipsTitle, tipsText])
        tipsSV.axis = .vertical
        let totalPriceSV = UIStackView(arrangedSubviews: [totalPriceTitle, totalPriceText])
        totalPriceSV.axis = .vertical
        let priceRowSV = UIStackView(arrangedSubviews: [priceSV, tipsSV, totalPriceSV])
        priceRowSV.axis = .horizontal
        priceRowSV.distribution = .fillEqually
        
        let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuTextLabel, priceRowSV, memoTitleLabel, memoTextLabel, editReportButton])
        contentView.addSubview(menuSV)
        menuSV.axis = .vertical
        menuSV.distribution = .equalSpacing
        menuSV.spacing = 15
        menuSV.anchors(topAnchor: pageControl.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, padding: .init(top: 0, left: 10, bottom: 20, right: 10))
        
        // after 'self' is instantiated
        editReportButton.addTarget(self, action: #selector(editReportButtonPressed), for: .touchUpInside)
    }
    
    @objc func editReportButtonPressed() {
        print("editbuttonPressed")
        self.delegate?.editReportItemButtonPressed(report: reportItem)
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
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let menuTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "off + Jal Nail + design"
        return lb
    }()
    
    let memoTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let memoTextLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
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
    
    let priceTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Price"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let priceText: UILabel = {
        let lb = UILabel()
        lb.text = "$ 60.00"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    let tipsTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Tips"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        
        return lb
    }()
    
    let tipsText: UILabel = {
        let lb = UILabel()
        lb.text = "$ 6.00"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    let totalPriceTitle: UILabel = {
        let lb = UILabel()
        lb.text = "total"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        
        return lb
    }()
    
    let totalPriceText: UILabel = {
        let lb = UILabel()
        lb.text = "$ 6.00"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()

    let editReportButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Edit", for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitleColor(.black, for: .normal)
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 10
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        bt.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        bt.layer.borderColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1).cgColor
        bt.setImage(UIImage(named: "editicon1"), for: .normal)
        return bt
    }()
}

