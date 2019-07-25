//
//  ReportDetailViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-16.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController, UIScrollViewDelegate {
  
  var snapshotImages = [Data]()
  
  var report: ReportItem! {
    didSet {
      
      fullNameLabel.text = "\(report.client!.firstName!) \(report.client?.lastName ?? "")"
      let formatter = DateFormatter()
      if let date = report.visitDate {
        formatter.dateFormat = "YYYY/MM/dd"
        visitDateLabel.text = formatter.string(from: date)
      }
      formatter.dateFormat = "HH:mm"
      var startStr = ""
      var endStr = ""
      if let start = report.startTime {
        startStr = formatter.string(from: start)
      }
      if let end = report.endTime {
        endStr = formatter.string(from: end)
      }
      timeLabel.text = "\(startStr) ~ \(endStr)"
      snapshotImages.removeAll()
      if let snapshot1 = report.snapshot1 {
        snapshotImages.append(snapshot1)
      }
      if let snapshot2 = report.snapshot2 {
        snapshotImages.append(snapshot2)
      }
      if let snapshot3 = report.snapshot3 {
        snapshotImages.append(snapshot3)
      }
      if let snapshot4 = report.snapshot4 {
        snapshotImages.append(snapshot4)
      }
      memoLabel.text = report.memo ?? ""
      addImageToScrollView(images: snapshotImages)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationUI()
    setupUI()
  }
  
  func setupUI() {
    view.addSubview(scrollView)
    scrollView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
    scrollView.frame = self.view.frame
    
    visitDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    let dateTimeSV = UIStackView(arrangedSubviews: [visitDateLabel, timeLabel])
    dateTimeSV.axis = .horizontal
    dateTimeSV.spacing = 10
    
    let nameDateSV = UIStackView(arrangedSubviews: [fullNameLabel, dateTimeSV])
    nameDateSV.axis = .vertical
    nameDateSV.alignment = .leading
    nameDateSV.spacing = 3
    
    let headerNameSV = UIStackView(arrangedSubviews: [clientImageView, nameDateSV])
    headerNameSV.axis = .horizontal
    headerNameSV.alignment = .center
    headerNameSV.spacing = 16
    
    scrollView.addSubview(headerNameSV)
    headerNameSV.translatesAutoresizingMaskIntoConstraints = false
    headerNameSV.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 7).isActive = true
    headerNameSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14).isActive = true
    headerNameSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    headerNameSV.heightAnchor.constraint(equalToConstant: 45).isActive = true
    
    scrollView.addSubview(nailScrollImageView)
    nailScrollImageView.delegate = self
    nailScrollImageView.topAnchor.constraint(equalTo: headerNameSV.bottomAnchor, constant: 10).isActive = true
    nailScrollImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    nailScrollImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    let height = view.bounds.width
    nailScrollImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    setupNailScrollView()
    setupPageNation()
    setupDiscription()
  }
  
  func setupNavigationUI() {
    navigationController?.navigationBar.barTintColor = UIColor(red: 217/255, green: 83/255, blue: 79/255, alpha: 1)
    navigationItem.title = "Detail"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationItem.rightBarButtonItem = submenuButton
    
  }
  
  func setupNailScrollView() {
    nailScrollImageView.backgroundColor = .white
    nailScrollImageView.contentSize = CGSize(width: (view.bounds.width) * CGFloat(snapshotImages.count), height: nailScrollImageView.bounds.height)
    nailScrollImageView.isUserInteractionEnabled = true
    nailScrollImageView.isPagingEnabled = true
    nailScrollImageView.showsHorizontalScrollIndicator = false
    nailScrollImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    nailScrollImageView.layoutIfNeeded()
    addImageToScrollView(images: snapshotImages)
  }
  
  func setupPageNation() {
    scrollView.addSubview(pageControl)
    pageControl.defersCurrentPageDisplay = true
    pageControl.numberOfPages = snapshotImages.count
    pageControl.pageIndicatorTintColor = UIColor.init(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
    pageControl.currentPageIndicatorTintColor = UIColor.init(red: 107/255, green: 163/255, blue: 239/255, alpha: 1)
    pageControl.anchors(topAnchor: nailScrollImageView.bottomAnchor,
                        leadingAnchor: nailScrollImageView.leadingAnchor,
                        trailingAnchor: nailScrollImageView.trailingAnchor,
                        bottomAnchor: nil)
  }
  
  func setupDiscription() {
    let menuContentSV = UIStackView(arrangedSubviews: [menuContentLabel, menuContentPrice])
    menuContentSV.axis = .horizontal
    
    let menuContentSV2 = UIStackView(arrangedSubviews: [menuContentLabel2, menuContentPrice2])
    menuContentSV.axis = .horizontal
    
    let allMenuContentSV = UIStackView(arrangedSubviews: [menuContentSV, menuContentSV2])
    allMenuContentSV.axis = .vertical
    allMenuContentSV.spacing = 8
    allMenuContentSV.alignment = .trailing
    
    let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, allMenuContentSV])
    menuSV.axis = .horizontal
    menuSV.alignment = .top
    menuSV.spacing = 10
    
    scrollView.addSubview(menuSV)
    menuSV.translatesAutoresizingMaskIntoConstraints = false
    menuSV.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
    menuSV.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
    menuSV.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    
    let priceView = UIView()
    scrollView.addSubview(priceView)
    priceView.translatesAutoresizingMaskIntoConstraints = false
    priceView.addBorders(edges: .bottom, color: UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1), width: 2)
    priceView.topAnchor.constraint(equalTo: menuSV.bottomAnchor, constant: 30).isActive = true
    priceView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
    priceView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    priceView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    let subtotalSV = UIStackView(arrangedSubviews: [subtotalTitleLabel, subtotalPrice])
    subtotalSV.axis = .horizontal
    subtotalSV.distribution = .fillEqually
    
    let taxSV = UIStackView(arrangedSubviews: [taxTitleLabel, taxPrice])
    taxSV.axis = .horizontal
    taxSV.distribution = .fillEqually
    
    let tipsSV = UIStackView(arrangedSubviews: [tipsTitleLabel, tipsPrice])
    tipsSV.axis = .horizontal
    tipsSV.distribution = .fillEqually
    
    let priceSV = UIStackView(arrangedSubviews: [subtotalSV, taxSV, tipsSV])
    priceSV.axis = .vertical
    priceSV.spacing = 4
    
    priceView.addSubview(priceSV)
    priceSV.translatesAutoresizingMaskIntoConstraints = false
    priceSV.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
    priceSV.widthAnchor.constraint(equalTo: priceView.widthAnchor).isActive = true
    priceSV.centerXAnchor.constraint(equalTo: priceView.centerXAnchor).isActive = true
    
    scrollView.addSubview(totalPrice)
    totalPrice.translatesAutoresizingMaskIntoConstraints = false
    totalPrice.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 10).isActive = true
    totalPrice.widthAnchor.constraint(equalTo: priceView.widthAnchor).isActive = true
    totalPrice.centerXAnchor.constraint(equalTo: priceView.centerXAnchor).isActive = true
    
    let memoSV = UIStackView(arrangedSubviews: [memoTitleLable, memoLabel])
    memoSV.axis = .vertical
    memoSV.spacing = 4
    
    scrollView.addSubview(memoSV)
    memoSV.translatesAutoresizingMaskIntoConstraints = false
    memoSV.topAnchor.constraint(equalTo: totalPrice.bottomAnchor, constant: 20).isActive = true
    memoSV.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
    memoSV.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    
    // natural contentSize
    let height = memoLabel.intrinsicContentSize.height + 780
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
    
  }
  
  
  func addImageToScrollView(images: [Data]) {
    let width = nailScrollImageView.bounds.width
    let height = nailScrollImageView.bounds.height
    
    for i in 0..<snapshotImages.count {
      let iv = UIImageView(frame: CGRect.init(x: 0 + width * CGFloat(i), y: 0, width: width, height: height))
      iv.backgroundColor = .white
      iv.image = UIImage(data: images[i])
      iv.isUserInteractionEnabled = true
      iv.contentMode = .scaleAspectFit
      nailScrollImageView.addSubview(iv)
    }
  }
  
  @objc func submenuButtonPressed() {
    let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)
    let editAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default, handler:{
      (action: UIAlertAction!) -> Void in
      let editVC = NewReportViewController()
      editVC.report = self.report
      // callback closure when dismiss
      editVC.reload = { [unowned self] (editReport) in
        // set report -> didSet -> reload
        self.report = editReport
      }
      let editNVC = LightStatusNavigationController(rootViewController: editVC)
      self.present(editNVC, animated: true, completion: nil)
    })
    let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler:{
      (action: UIAlertAction!) -> Void in
      print("delete")
      
    })
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
      (action: UIAlertAction!) -> Void in
      
    })
    
    alert.addAction(editAction)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
  }
  
  func updateCurrentPageDisplay() {
    print(pageControl.currentPage)
  }
  
  // UI Parts
  
  lazy var submenuButton: UIBarButtonItem = {
    let bt = UIBarButtonItem(image: #imageLiteral(resourceName: "menudot"), style: .plain, target: self, action: #selector(submenuButtonPressed))
    bt.tintColor = .white
    return bt
  }()
  
  let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.backgroundColor = .white
    return sv
  }()
  
  let clientImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "beautiful-blur-blurred-background-733872"))
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.constraintWidth(equalToConstant: 45)
    iv.layer.cornerRadius = 23
    iv.layer.masksToBounds = true
    return iv
  }()
  
  let fullNameLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Andrew Samanth"
    lb.font = UIFont.boldSystemFont(ofSize: 16)
    return lb
  }()
  
  let visitDateLabel: UILabel = {
    let lb = UILabel()
    lb.text = "2019/07/01"
    lb.font = UIFont.systemFont(ofSize: 14)
    lb.textColor = UIColor.init(red: 156/255, green: 166/255, blue: 181/255, alpha: 1)
    return lb
  }()
  
  let timeLabel: UILabel = {
    let lb = UILabel()
    lb.text = "12:00 ~ 14:00"
    lb.font = UIFont.systemFont(ofSize: 14)
    lb.textColor = UIColor(red: 156/255, green: 166/255, blue: 181/255, alpha: 1)
    return lb
  }()
  
  let nailScrollImageView: UIScrollView = {
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
  
  let menuTitleLabel: UILabel = {
    let lb = UILabel()
    lb.text = "MENU"
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    return lb
  }()
  
  let menuContentLabel: menuTagLabel = {
    let lb = menuTagLabel()
    lb.text = "Design"
    lb.textColor = .white
    lb.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    lb.layer.cornerRadius = 12
    lb.layer.masksToBounds = true
    return lb
  }()
  
  let menuContentPrice: UILabel = {
    let lb = UILabel()
    lb.text = "$ 10.00"
    lb.textAlignment = .right
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    lb.constraintWidth(equalToConstant: 80)
    return lb
  }()
  
  let menuContentLabel2: menuTagLabel = {
    let lb = menuTagLabel()
    lb.text = "Jel"
    lb.textColor = .white
    lb.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    lb.layer.cornerRadius = 12
    lb.layer.masksToBounds = true
    return lb
  }()
  
  let menuContentPrice2: UILabel = {
    let lb = UILabel()
    lb.text = "$ 12.00"
    lb.textAlignment = .right
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    lb.constraintWidth(equalToConstant: 80)
    return lb
  }()
  
  let subtotalTitleLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Subtotal"
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    return lb
  }()
  
  let subtotalPrice: UILabel = {
    let lb = UILabel()
    lb.text = "$ 120.00"
    lb.textAlignment = .right
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    return lb
  }()
  
  let tipsTitleLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Tips"
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    return lb
  }()
  
  let tipsPrice: UILabel = {
    let lb = UILabel()
    lb.text = "$ 12.00"
    lb.textAlignment = .right
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    return lb
  }()
  
  let taxTitleLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Tax"
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    return lb
  }()
  
  let taxPrice: UILabel = {
    let lb = UILabel()
    lb.text = "$ 12.00"
    lb.textAlignment = .right
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let totalPrice: UILabel = {
    let lb = UILabel()
    lb.text = "$ 140.00"
    lb.textAlignment = .right
    lb.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let memoTitleLable: UILabel = {
    let lb = UILabel()
    lb.text = "MEMO"
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    return lb
  }()
  
  lazy var memoLabel: UILabel = {
    let lb = UILabel()
    lb.numberOfLines = 0
    var labelframe = lb.frame
    lb.frame.origin.x = 0
    lb.frame.origin.y = labelframe.origin.y + labelframe.size.height
    lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    lb.text = """
    discription
    discription
    discription
    """
    return lb
  }()
  
}

