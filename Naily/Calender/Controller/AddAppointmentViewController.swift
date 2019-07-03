//
//  AddAppointmentViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-29.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class AddAppointmentViewController: UIViewController {
    
    var selectClient: ClientInfo! {
        didSet {
            if let image = selectClient.clientImage {
                clientImageView.image = UIImage(data: image)
            }
            firstNameLabel.text = selectClient.firstName
            lastNameLabel.text = selectClient.lastName ?? ""
        }
    }
    
    var selectAppointment: Appointment! {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let date = selectAppointment.appointmentDate {
                dateTextView.text = formatter.string(from: date)
            }
            formatter.dateFormat = "HH:mm"
            if let start = selectAppointment.start {
                startTextView.text = formatter.string(from: start)
            }
            if let end = selectAppointment.end {
                endTextView.text = formatter.string(from: end)
            }
            menuTextView.text = selectAppointment.menu ?? ""
            memoTextView.text = selectAppointment.memo ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationUI()
    }
    
    private func setupUI() {
        view.addSubview(formScrollView)
        formScrollView.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
        formScrollView.contentSize.height = 800
        
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
        
        firstNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let nameSV = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        nameSV.translatesAutoresizingMaskIntoConstraints = false
        nameSV.axis = .horizontal
        nameSV.spacing = 10
        
        let clientInfoViewContentSV = UIStackView(arrangedSubviews: [clientImageView, nameSV])
        clientInfoViewContentSV.translatesAutoresizingMaskIntoConstraints = false
        clientInfoViewContentSV.axis = .horizontal
        clientInfoViewContentSV.spacing = 20
        clientInfoViewContentSV.alignment = .center
        clientInfoViewContentSV.distribution = .fillProportionally
        
        clientInfoView.addSubview(clientInfoViewContentSV)
        clientInfoViewContentSV.topAnchor.constraint(equalTo: clientInfoView.topAnchor, constant: 10).isActive = true
        clientInfoViewContentSV.bottomAnchor.constraint(equalTo: clientInfoView.bottomAnchor, constant: 10)
        clientInfoViewContentSV.centerXAnchor.constraint(equalTo: clientInfoView.centerXAnchor).isActive = true
        clientInfoViewContentSV.widthAnchor.constraint(equalTo: clientInfoView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        let dateSV = UIStackView(arrangedSubviews: [dateTitleLabel, dateTextView])
        dateSV.translatesAutoresizingMaskIntoConstraints = false
        dateSV.axis = .horizontal
        dateSV.spacing = 20
        
        let startSV = UIStackView(arrangedSubviews: [startTitleLabel, startTextView])
        startSV.translatesAutoresizingMaskIntoConstraints = false
        startSV.axis = .horizontal
        startSV.spacing = 50
        
        let endSV = UIStackView(arrangedSubviews: [endTitleLabel, endTextView])
        endSV.translatesAutoresizingMaskIntoConstraints = false
        endSV.axis = .horizontal
        endSV.spacing = 50
        
        let timeSV = UIStackView(arrangedSubviews: [dateSV, startSV, endSV])
        timeSV.translatesAutoresizingMaskIntoConstraints = false
        timeSV.axis = .vertical
        timeSV.spacing = 10
        
        let menuSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuTextView])
        menuSV.translatesAutoresizingMaskIntoConstraints = false
        menuSV.axis = .vertical
        menuSV.spacing = 5
        
        let memoSV = UIStackView(arrangedSubviews: [memoTitelLable, memoTextView])
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.axis = .vertical
        memoSV.spacing = 5
        
        let formSV = UIStackView(arrangedSubviews: [timeSV, menuSV, memoSV])
        formSV.translatesAutoresizingMaskIntoConstraints = false
        formSV.spacing = 15
        formSV.axis = .vertical
        
        formScrollView.addSubview(formSV)
        formSV.topAnchor.constraint(equalTo: clientInfoView.bottomAnchor, constant: 30).isActive = true
        formSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.7).isActive = true
        formSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupNavigationUI() {
        navigationItem.title = selectAppointment == nil ? "Add Appointment" : "Edit Appointment"
        saveButton.isEnabled = selectAppointment == nil ? false : true
        navigationItem.rightBarButtonItem = saveButton
        
        if selectAppointment != nil {
            let cancelButton: UIBarButtonItem = {
                let bb = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
                return bb
            }()
            navigationItem.leftBarButtonItem = cancelButton
        }

    }
    
    @objc func tappedClientView() {
        print("tappedClientView")
        let custmerVC = CustomerCollectionViewController()
        custmerVC.title = "Select Client"
        custmerVC.selectClient = true
        custmerVC.delegate = self
        self.navigationController?.pushViewController(custmerVC, animated: true)
    }
    
    let fetchedAppointmentItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Appointment> in
        let fetchRequest = NSFetchRequest<Appointment>(entityName: "Appointment")
        let appointmentDateDescriptors = NSSortDescriptor(key: "appointmentDate", ascending: true)
        fetchRequest.sortDescriptors = [appointmentDateDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    @objc func saveButtonPressed() {
        print("save")
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        if selectAppointment == nil {
            let newAppointment = NSEntityDescription.insertNewObject(forEntityName: "Appointment", into: manageContext)
            
            newAppointment.setValue(dateTextView.toolbar.datePicker.date, forKey: "appointmentDate")
            newAppointment.setValue(startTextView.toolbar.datePicker.date, forKey: "start")
            newAppointment.setValue(endTextView.toolbar.datePicker.date, forKey: "end")
            newAppointment.setValue(selectClient, forKey: "client")
            if let menu = memoTextView.text {
                newAppointment.setValue(menu, forKey: "menu")
            }
            if let memo = memoTextView.text {
                newAppointment.setValue(memo, forKey: "memo")
            }
            do {
                try fetchedAppointmentItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed insert appointment into CoreData - \(err)")
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            if let client = selectClient {
                selectAppointment.client = client
            }
            if dateTextView.text != "" {
                selectAppointment.appointmentDate = dateTextView.toolbar.datePicker.date
            }
            if startTextView.text != "" {
                selectAppointment.start = startTextView.toolbar.datePicker.date
            }
            if endTextView.text != "" {
                selectAppointment.end = endTextView.toolbar.datePicker.date
            }
            selectAppointment.menu = menuTextView.text ?? ""
            selectAppointment.memo = memoTextView.text ?? ""
            do {
                try fetchedAppointmentItemResultsController.managedObjectContext.save()
            } catch let err {
                print("edit appointment failed - \(err)")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        
        if menuTextView.isFirstResponder || memoTextView.isFirstResponder {
            self.view.frame.origin.y = -keyboardFrameHeight
        }
        else {
//            self.view.frame.origin.y = -keyboardFrameHeight
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    // UIParts
    private let formScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1303125962, green: 0.7764329663, blue: 0.4930842745, alpha: 0.2029049296))
        return sv
    }()
    
    private let clientInfoView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = #colorLiteral(red: 1, green: 0.8284288049, blue: 0.8181912303, alpha: 1)
        cv.layer.cornerRadius = 10
        cv.clipsToBounds = true
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
        iv.constraintWidth(equalToConstant: 60)
        iv.constraintHeight(equalToConstant: 60)
        return iv
    }()
    
    private let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SELECT Client"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let lastVistiDate: UILabel = {
        let lb = UILabel()
        lb.text = "2019/05/21"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12.0)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    private let dateTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Date"
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
        lb.text = "Start"
        return lb
    }()
    
    private let startTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.center
        tp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return tp
    }()
    
    private let endTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "End"
        return lb
    }()
    
    private let endTextView: TimePickerKeyboard = {
        let tp = TimePickerKeyboard()
        tp.font = UIFont.systemFont(ofSize: 18)
        tp.textAlignment = NSTextAlignment.center
        tp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return tp
    }()
    
    private let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        return lb
    }()
    
    private let menuTextView: MyTextView = {
        let tv = MyTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.constraintHeight(equalToConstant: 150)
        return tv
    }()
    
    private let memoTitelLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "MEMO"
        return lb
    }()
    
    private let memoTextView: MyTextView = {
        let tv = MyTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.constraintHeight(equalToConstant: 150)
        return tv
    }()

}

extension AddAppointmentViewController: CustomerCollectionViewControllerDelegate {
    func selectedClient(client: ClientInfo) {
        self.selectClient = client
        if let image = client.clientImage {
            clientImageView.image = UIImage(data: image)
        }
        firstNameLabel.text = client.firstName
        lastNameLabel.text = client.lastName ?? ""
        
        saveButton.isEnabled = true
    }
    
    
}
