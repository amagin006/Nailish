//
//  AddAppointmentViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-29.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

private let appointmentCellId = "appointmentCellId"

class AddAppointmentViewController: FetchTableViewController, UITableViewDataSource {
    var selectedMenuItems: Set<SelectedMenuItem> = []
    var selectedMenuItemArray = [SelectedMenuItem]()
    var selectClient: ClientInfo?
    var selectedDate: Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            if let date = selectedDate {
                dateTextView.text = formatter.string(from: date)
            }
        }
    }
    
    var reportItem: ReportItem! {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            if let date = reportItem.visitDate {
                dateTextView.text = formatter.string(from: date)
            }
            formatter.dateFormat = "HH:mm"
            if let startTime = reportItem.startTime {
                startTextView.text = formatter.string(from: startTime)
            }
            if let endTime = reportItem.endTime {
                endTextView.text = formatter.string(from: endTime)
            }
            if let menu = reportItem.menuItem {
                let newArray = Array(menu) as! [SelectedMenuItem]
                selectedMenuItemArray = newArray.sorted { $0.tag < $1.tag }
                menuTableView.reloadData()
            }
            if let memo = reportItem.memo {
                memoTextView.text = memo
            }
            if let image = reportItem.client!.clientImage {
                clientImageView.image = UIImage(data: image)
            }
            if let firstName = reportItem.client!.firstName {
                nameLabel.text = "\(firstName) \(reportItem.client!.lastName ?? "")"
            }
            if let client = reportItem.client {
                selectClient = client
                clientInfoView.backgroundColor = UIColor(red: 255/255, green: 238/255, blue: 173/255, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tableView = menuTableView
        setupUI()
        setupNavigationUI()
    }
    
    private func setupUI() {
        view.addSubview(formScrollView)
        formScrollView.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
        formScrollView.contentSize.height = 900
        
        formScrollView.addSubview(clientInfoView)
        clientInfoView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        clientInfoView.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        clientInfoView.topAnchor.constraint(equalTo: formScrollView.topAnchor, constant: 20).isActive = true
        clientInfoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedClientView))
        clientInfoView.addGestureRecognizer(gesture)
        clientInfoView.layer.shadowColor = UIColor.black.cgColor
        clientInfoView.layer.shadowOffset = CGSize(width: 4, height: 4)
        clientInfoView.layer.shadowRadius = 0.5
        clientInfoView.layer.masksToBounds = false
        clientInfoView.layer.shadowOpacity = 0.2
        
        let clientInfoViewContentSV = UIStackView(arrangedSubviews: [clientImageView, nameLabel])
        clientInfoViewContentSV.translatesAutoresizingMaskIntoConstraints = false
        clientInfoViewContentSV.axis = .horizontal
        clientInfoViewContentSV.spacing = 20
        clientInfoViewContentSV.alignment = .center
        clientInfoViewContentSV.distribution = .fillProportionally
        
        clientInfoView.addSubview(clientInfoViewContentSV)
        clientInfoViewContentSV.topAnchor.constraint(equalTo: clientInfoView.topAnchor, constant: 10).isActive = true
        clientInfoViewContentSV.bottomAnchor.constraint(equalTo: clientInfoView.bottomAnchor, constant: 10)
        clientInfoViewContentSV.centerXAnchor.constraint(equalTo: clientInfoView.centerXAnchor).isActive = true
        clientInfoViewContentSV.widthAnchor.constraint(equalTo: clientInfoView.widthAnchor, multiplier: 0.9).isActive = true
        
        dateTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let dateSV = UIStackView(arrangedSubviews: [dateTitleLabel, dateTextView])
        dateSV.axis = .horizontal
        dateSV.spacing = 20
        
        let startSV = UIStackView(arrangedSubviews: [startTitleLabel, startTextView])
        startSV.axis = .vertical
        startSV.spacing = 5
        
        let endSV = UIStackView(arrangedSubviews: [endTitleLabel, endTextView])
        endSV.axis = .vertical
        endSV.spacing = 5
        
        let timeSV = UIStackView(arrangedSubviews: [startSV, endSV])
        timeSV.axis = .horizontal
        timeSV.spacing = 20
        timeSV.distribution = .fillEqually
        
        let dateAndTimeSV = UIStackView(arrangedSubviews: [dateSV, timeSV])
        dateAndTimeSV.axis = .vertical
        dateAndTimeSV.spacing = 20
        
        formScrollView.addSubview(dateAndTimeSV)
        dateAndTimeSV.translatesAutoresizingMaskIntoConstraints = false
        dateAndTimeSV.topAnchor.constraint(equalTo: clientInfoView.bottomAnchor, constant: 30).isActive = true
        dateAndTimeSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        dateAndTimeSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        formScrollView.addSubview(addMenuButton)
        addMenuButton.translatesAutoresizingMaskIntoConstraints = false
        addMenuButton.topAnchor.constraint(equalTo: dateAndTimeSV.bottomAnchor, constant: 40).isActive = true
        addMenuButton.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        menuTableView.register(MenuMasterTableViewCell.self, forCellReuseIdentifier: appointmentCellId)
        
        let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuTableView])
        menuSV.translatesAutoresizingMaskIntoConstraints = false
        menuSV.axis = .vertical
        menuSV.spacing = 5
        
        let memoSV = UIStackView(arrangedSubviews: [memoTitelLable, memoTextView])
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.axis = .vertical
        memoSV.spacing = 5
        
        let menuAndMemoSV = UIStackView(arrangedSubviews: [menuSV, memoSV])
        menuAndMemoSV.translatesAutoresizingMaskIntoConstraints = false
        menuAndMemoSV.spacing = 20
        menuAndMemoSV.axis = .vertical
        
        formScrollView.addSubview(menuAndMemoSV)
        menuAndMemoSV.topAnchor.constraint(equalTo: addMenuButton.bottomAnchor, constant: 30).isActive = true
        menuAndMemoSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        menuAndMemoSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        if reportItem != nil {
            formScrollView.addSubview(deleteButton)
            deleteButton.topAnchor.constraint(equalTo: menuAndMemoSV.bottomAnchor, constant: 70).isActive = true
            deleteButton.widthAnchor.constraint(greaterThanOrEqualTo: formScrollView.widthAnchor, multiplier: 0.4).isActive = true
            deleteButton.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
            formScrollView.contentSize.height = 1000
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupNavigationUI() {
        navigationItem.title = reportItem == nil ? "Add Appointment" : "Edit Appointment"
        saveButton.isEnabled = reportItem == nil ? false : true
        navigationItem.rightBarButtonItem = saveButton
        
        if reportItem != nil {
            let cancelButton: UIBarButtonItem = {
                let bb = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
                return bb
            }()
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc func tappedClientView() {
        let custmerVC = CustomerCollectionViewController()
        custmerVC.title = "Select Client"
        custmerVC.selectClient = true
        custmerVC.delegate = self
        self.navigationController?.pushViewController(custmerVC, animated: true)
    }
    
    @objc func deleteReport() {
        let alert: UIAlertController = UIAlertController(title: "Delete Report", message: "Are you sure you want to delete client?", preferredStyle: .alert)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler:{
            (action: UIAlertAction!) in
            
            let managementContent = CoreDataManager.shared.viewContext
            managementContent.delete(self.reportItem)
            do {
                try self.fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed delete client - \(err)")
            }
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (action: UIAlertAction!) in
            
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        let manageContext = CoreDataManager.shared.viewContext
        if reportItem == nil {
            let newReport = NSEntityDescription.insertNewObject(forEntityName: "ReportItem", into: manageContext)
            for i in 0..<4 {
                let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))
                let imageData = iv.image?.jpegData(compressionQuality: 0.1)
                newReport.setValue(imageData, forKey: "snapshot\(i + 1)")
            }
            
            newReport.setValue(selectClient, forKey: "client")
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            let date = formatter.date(from: dateTextView.text)
            newReport.setValue(date, forKey: "visitDate")
            formatter.dateFormat = "HH:mm"
            if startTextView.text != nil && startTextView.text != "" {
                let start = formatter.date(from: startTextView.text)
                newReport.setValue(start, forKey: "startTime")
            }
            else {
                let start = startTextView.toolbar.datePicker.date
                newReport.setValue(start, forKey: "startTime")
            }
            if endTextView.text != nil && endTextView.text != "" {
                let end = formatter.date(from: endTextView.text)
                newReport.setValue(end, forKey: "endTime")
            }
            else {
                let end = endTextView.toolbar.datePicker.date
                newReport.setValue(end, forKey: "endTime")
            }
        
            newReport.setValue(selectedMenuItems, forKey: "selectedMenuItems")
            if let memo = memoTextView.text {
                newReport.setValue(memo, forKey: "memo")
            }
            do {
                try fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed save Report - \(err)")
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            reportItem.client = selectClient
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            reportItem.visitDate = formatter.date(from: dateTextView.text)
            formatter.dateFormat = "HH:mm"
            if startTextView.text != nil {
                let time = formatter.date(from: startTextView.text)
                reportItem.startTime = time
            }
            if endTextView.text != nil {
                let time = formatter.date(from: endTextView.text)
                reportItem.endTime = time
            }
            reportItem.menuItem = NSSet(set: selectedMenuItems)
            reportItem.memo = memoTextView.text ?? ""
            do {
                try fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("edit appointment failed - \(err)")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addMenu() {
        let menuSelectTableVC = MenuSelectTableViewController()
        menuSelectTableVC.delegate = self
        let menuSelectTableNVC = LightStatusNavigationController(rootViewController: menuSelectTableVC)
        self.present(menuSelectTableNVC, animated: true, completion: nil)
    }
    
    @objc func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        if memoTextView.isFirstResponder {
            self.view.frame.origin.y = -keyboardFrameHeight
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // menuTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !selectedMenuItemArray.isEmpty {
            return selectedMenuItemArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: appointmentCellId, for: indexPath) as! MenuMasterTableViewCell
        cell.selectionStyle = .none
        if !selectedMenuItemArray.isEmpty {
            cell.menuitemTagLabel.text = selectedMenuItemArray[indexPath.row].menuName
            let color = TagColor.stringToSGColor(str: selectedMenuItemArray[indexPath.row].color!)
            cell.menuitemTagLabel.backgroundColor = color?.rawValue
            // TODO: set price Label
            let fm = NumberFormatter()
            fm.numberStyle = .decimal
            fm.maximumFractionDigits = 2
            fm.minimumFractionDigits = 2
            cell.priceLabel.text = fm.string(from: selectedMenuItemArray[indexPath.row].price!)
        }
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // UIParts
    private let formScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return sv
    }()
    
    private let clientInfoView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.addBorders(edges: .left, color: UIColor(red: 23/255, green: 144/255, blue: 111/255, alpha: 1), width: 3)
        return cv
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let bb = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
        return bb
    }()
    
    private let clientImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person3"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1).cgColor
        iv.constraintWidth(equalToConstant: 60)
        iv.constraintHeight(equalToConstant: 60)
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SELECT Client"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    private let dateTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Visit Date"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    private let dateTextView: DatePickerKeyboard = {
        let dp = DatePickerKeyboard()
        dp.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dp.textAlignment = NSTextAlignment.center
        dp.font = UIFont.systemFont(ofSize: 18)
        return dp
    }()
    
    private let startTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start Time"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    private let startTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.center
        return tp
    }()
    
    private let endTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "End Time"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    private let endTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.center
        return tp
    }()
    
    private let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        return lb
    }()
    
    let addMenuButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(red: 255/255, green: 162/255, blue: 162/255, alpha: 1)
        bt.setTitle("SELECT MENU", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.constraintWidth(equalToConstant: 200)
        bt.constraintHeight(equalToConstant: 40)
        bt.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
        bt.setBackgroundColor(UIColor(red: 255/255, green: 162/255, blue: 162/255, alpha: 1), for: .normal)
        bt.setBackgroundColor(UIColor(red: 178/255, green: 114/255, blue: 114/255, alpha: 1), for: .selected)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        let plusImage = #imageLiteral(resourceName: "plus")
        bt.setImage(plusImage.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: plusImage.size.width / 2)
        bt.contentHorizontalAlignment = .center
        return bt
    }()
    
    let menuTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = true
        return tv
    }()
    
    private let memoTitelLable: UILabel = {
        let lb = UILabel()
        lb.text = "MEMO"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.textColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        return lb
    }()
    
    private let memoTextView: MyTextView = {
        let tv = MyTextView()
        tv.constraintHeight(equalToConstant: 150)
        return tv
    }()
    
    let deleteButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Delete Report", for: .normal)
        bt.backgroundColor = .red
        bt.addTarget(self, action: #selector(deleteReport), for: .touchUpInside)
        bt.layer.cornerRadius = 10
        return bt
    }()

}

extension AddAppointmentViewController: MenuSelectTableViewControllerDelegate, CustomerCollectionViewControllerDelegate {
    // MenuSelectTableViewControllerDelegate
    func newReportSaveTapped(selectMenu: Set<SelectedMenuItem>) {
        selectedMenuItems = selectMenu
        selectedMenuItemArray.removeAll()
        selectedMenuItemArray = Array(selectMenu).sorted { $0.tag < $1.tag }
        menuTableView.reloadData()
    }
    
    // CustomerCollectionViewControllerDelegate
    func selectedClient(client: ClientInfo) {
        self.selectClient = client
        if let image = client.clientImage {
            clientImageView.image = UIImage(data: image)
        }
        clientInfoView.backgroundColor = UIColor(red: 255/255, green: 238/255, blue: 173/255, alpha: 1)
        nameLabel.text = "\(client.firstName!) \(client.lastName ?? "")"
        saveButton.isEnabled = true
    }    
}
