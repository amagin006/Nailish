//
//  NewReportViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-13.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData
import Photos

class NewReportViewController: UIViewController {
    
    var reportImageViews = [UIImageView]()
    var reportImages = [UIImage]()
    var selectImageNum = 0
    var client: ClientInfo?
    var reload: ((ReportItem) -> ())?
    var report: ReportItem? {
        didSet {
            if let image1 = report?.snapshot1, let image2 = report?.snapshot2,
                let image3 = report?.snapshot3, let image4 = report?.snapshot4 {
                reportImages.append(UIImage(data: image1)!)
                reportImages.append(UIImage(data: image2)!)
                reportImages.append(UIImage(data: image3)!)
                reportImages.append(UIImage(data: image4)!)
                for i in 0..<reportImages.count {
                    let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))
                    iv.layer.borderWidth = 2
                    iv.layer.borderColor = UIColor.lightGray.cgColor
                    iv.translatesAutoresizingMaskIntoConstraints = false
                    iv.isUserInteractionEnabled = true
                    iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
                    iv.tag = i
                    reportImageViews.append(iv)
                    reportImages.append(iv.image!)
                    reportImageViews[i].image = reportImages[i]
                    subImageSV.addArrangedSubview(reportImageViews[i])
                }
            }
            reportMainImageView.image = reportImages[0]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let date = report?.visitDate {
                visitTextField.text = formatter.string(from: date)
            }
            formatter.dateFormat = "HH:mm"
            if let start = report?.startTime {
                startTimeTextField.text = formatter.string(from: start)
            }
            if let end = report?.endTime {
                endTimeTextField.text = formatter.string(from: end)
            }
            if let tips = report?.tips {
                tipsTextField.text = String(tips)
            }
            memoTextView.text = report?.memo
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupUI()
    }
    
    lazy var fetchedReportItemResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ReportItem> in
        let fetchRequest = NSFetchRequest<ReportItem>(entityName: "ReportItem")
        let visitDateDescriptors = NSSortDescriptor(key: "visitDate", ascending: true)
        fetchRequest.sortDescriptors = [visitDateDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private func setupUI() {
        view.addSubview(formScrollView)
        formScrollView.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
        formScrollView.frame = self.view.frame
        formScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)

        formScrollView.addSubview(reportMainImageView)
        reportMainImageView.topAnchor.constraint(equalTo: formScrollView.topAnchor).isActive = true
        reportMainImageView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor).isActive = true
        reportMainImageView.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        reportMainImageView.heightAnchor.constraint(equalTo: formScrollView.widthAnchor).isActive = true
        
        for i in 0..<4 {
            if reportImageViews.count < 4 {
                let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))
                iv.layer.borderWidth = 2
                iv.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
                iv.translatesAutoresizingMaskIntoConstraints = false
                iv.isUserInteractionEnabled = true
                iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
                iv.tag = i
                reportImageViews.append(iv)
                reportImages.append(iv.image!)
                subImageSV.addArrangedSubview(reportImageViews[i])
            }
        }
        let reportImageViewHeight = reportImageViews[0].widthAnchor
        
        formScrollView.addSubview(subImageSV)
        subImageSV.distribution = .fillEqually
        subImageSV.spacing = 10
        subImageSV.topAnchor.constraint(equalTo: reportMainImageView.bottomAnchor, constant: 10).isActive = true
        subImageSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        subImageSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        subImageSV.heightAnchor.constraint(equalTo: reportImageViewHeight).isActive = true
        
        let visitDateSV = UIStackView(arrangedSubviews: [visitTitleLabel, visitTextField])
        visitDateSV.axis = .vertical
        visitDateSV.spacing = 3
        
        let startSV = UIStackView(arrangedSubviews: [startTimeTitleLabel, startTimeTextField])
        startSV.axis = .vertical
        startSV.spacing = 3
        
        let endSV = UIStackView(arrangedSubviews: [endTimeTitleLabel, endTimeTextField])
        endSV.axis = .vertical
        endSV.spacing = 3
        
        let timeSV = UIStackView(arrangedSubviews: [startSV, endSV])
        timeSV.axis = .horizontal
        timeSV.distribution = .fillEqually
        timeSV.spacing = 12
        
//        let priceSV = UIStackView(arrangedSubviews: [priceTitleLabel, priceTextField])
//        priceSV.axis = .vertical
//        priceSV.spacing = 5
//
//
//        let priceBoxSV = UIStackView(arrangedSubviews: [priceSV, tipsSV])
//        priceBoxSV.axis = .horizontal
//        priceBoxSV.distribution = .fillEqually
//        priceBoxSV.spacing = 10
//
//        let menuItemSV = UIStackView(arrangedSubviews: [menuTitleLabel])
//        menuItemSV.axis = .horizontal
//        menuItemSV.distribution = .fillProportionally
//        menuItemSV.spacing = 12
//        menuItemSV.alignment = .top
        
        let dateAndTimeSV = UIStackView(arrangedSubviews: [visitDateSV, timeSV])
        dateAndTimeSV.translatesAutoresizingMaskIntoConstraints = false
        dateAndTimeSV.axis = .vertical
        dateAndTimeSV.spacing = 16
        dateAndTimeSV.alignment = .fill
        formScrollView.addSubview(dateAndTimeSV)
        
        dateAndTimeSV.topAnchor.constraint(equalTo: subImageSV.bottomAnchor, constant: 20).isActive = true
        dateAndTimeSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        dateAndTimeSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        let menuView = UIView()
        formScrollView.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: dateAndTimeSV.bottomAnchor, constant: 30).isActive = true
        menuView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        menuView.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        menuView.backgroundColor = .yellow
        
        menuView.addSubview(addMenuButton)
        addMenuButton.topAnchor.constraint(equalTo: menuView.topAnchor).isActive = true
        addMenuButton.trailingAnchor.constraint(equalTo: menuView.trailingAnchor).isActive = true
        
        let menuItemSV = UIStackView(arrangedSubviews: [menuitemTagLabel, priceLabel])
        menuItemSV.axis = .horizontal
        menuItemSV.spacing = 20
        let menuItem2SV = UIStackView(arrangedSubviews: [menuitemTagLabel2, priceLabel2])
        menuItem2SV.axis = .horizontal
        menuItem2SV.spacing = 20
        
        let menuItemRowsSV = UIStackView(arrangedSubviews: [menuItemSV, menuItem2SV])
        menuItemRowsSV.axis = .vertical
        menuItemRowsSV.alignment = .trailing
        menuItemRowsSV.spacing = 10
        
        menuTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let menuboxSV = UIStackView(arrangedSubviews: [menuTitleLabel, menuItemRowsSV])
        menuboxSV.alignment = .top
        formScrollView.addSubview(menuboxSV)
        menuboxSV.translatesAutoresizingMaskIntoConstraints = false
        menuboxSV.topAnchor.constraint(equalTo: addMenuButton.bottomAnchor, constant: 30).isActive = true
        menuboxSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        menuboxSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        let tipsSV = UIStackView(arrangedSubviews: [tipsTitleLabel, tipsTextField])
        tipsSV.axis = .horizontal
        
        let tipAndMemoSV = UIStackView(arrangedSubviews: [tipsSV, memoLabel, memoTextView])
        formScrollView.addSubview(tipAndMemoSV)
        tipAndMemoSV.translatesAutoresizingMaskIntoConstraints = false
        tipAndMemoSV.spacing = 10
        tipAndMemoSV.axis = .vertical
        
        tipAndMemoSV.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 20).isActive = true
        tipAndMemoSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        tipAndMemoSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    private func setupNavigationUI() {
        navigationItem.title = report == nil ? "New Report" : "Edit Report"
        let cancelButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(reportCancelButtonPressed))
            return bt
        }()
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(reportSeveButtonPressed))
            return bt
        }()
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        selectImageNum = sender.view!.tag
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // handle authorized status
            self.editSelectImage()
        default:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    self.editSelectImage()
                default:
                    // won't happen but still
                    let cameraUnavailableAlertController = UIAlertController (title: "Photo Library Unavailable", message: "Please check to see if device settings doesn't allow photo library access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
                        let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                        if let url = settingsUrl {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    cameraUnavailableAlertController.addAction(settingsAction)
                    cameraUnavailableAlertController.addAction(cancelAction)
                    self.present(cameraUnavailableAlertController , animated: true, completion: nil)
                    break
                }
            }
        }
    }
    
    private func editSelectImage() {
        let imagePickController = UIImagePickerController()
        imagePickController.delegate = self
        imagePickController.sourceType = .photoLibrary
        imagePickController.allowsEditing = true
        
        present(imagePickController, animated: true, completion: nil)
    }
    
    @objc func reportCancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func reportSeveButtonPressed() {
        print("reportSeveButtonPressed")
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        if report == nil {
            let newReport = NSEntityDescription.insertNewObject(forEntityName: "ReportItem", into: manageContext)
            
            for i in 0..<reportImageViews.count {
                let imageData = reportImageViews[i].image?.jpegData(compressionQuality: 0.1)
                newReport.setValue(imageData, forKey: "snapshot\(i + 1)")
            }
            newReport.setValue(visitTextField.toolbar.datePicker.date, forKey: "visitDate")
            newReport.setValue(startTimeTextField.toolbar.datePicker.date, forKey: "startTime")
            newReport.setValue(endTimeTextField.toolbar.datePicker.date, forKey: "endTime")
            newReport.setValue(Int(tipsTextField.text ?? "0"), forKey: "tips")
            newReport.setValue(memoTextView.text ?? "", forKey: "memo")
            newReport.setValue(client, forKey: "client")
            do {
                try fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed save Report - \(err)")
            }
            dismiss(animated: true)
        } else {
            report?.snapshot1 = reportImageViews[0].image?.jpegData(compressionQuality: 0.1)
            report?.snapshot2 = reportImageViews[1].image?.jpegData(compressionQuality: 0.1)
            report?.snapshot3 = reportImageViews[2].image?.jpegData(compressionQuality: 0.1)
            report?.snapshot4 = reportImageViews[3].image?.jpegData(compressionQuality: 0.1)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let visitDateStr = visitTextField.text {
                report?.visitDate = formatter.date(from: visitDateStr)
            }
            formatter.dateFormat = "HH:mm"
            if let startTime = startTimeTextField.text {
                report?.startTime = formatter.date(from: startTime)
            }
            if let endTime = endTimeTextField.text {
                report?.endTime = formatter.date(from: endTime)
            }
            report?.tips = Int32(tipsTextField.text ?? "0")!
            report?.memo = memoTextView.text ?? ""
            do {
                try fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed save Report - \(err)")
            }
            dismiss(animated: true) { [unowned self] in
                self.reload?(self.report!)
            }
        }
    }
    
    @objc func tapMenu() {
        print("tapmenu")
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        
        if visitTextField.isFirstResponder {
            self.view.frame.origin.y = -visitTextField.toolbar.datePicker.frame.height
        }
        else {
            self.view.frame.origin.y = -keyboardFrameHeight
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // UIParts
    let formScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        return sv
    }()
    
    let reportMainImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let subImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))

        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
        return iv
    }()

    let subImageSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let visitTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Visit Day"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()

    let visitTextField: DatePickerKeyboard = {
        let tf = DatePickerKeyboard()
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return tf
    }()
    
    let startTimeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let startTimeTextField: TimePickerKeyboard = {
        let lb = TimePickerKeyboard()
        lb.layer.borderWidth = 0
        lb.layer.cornerRadius = 0
        lb.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        lb.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return lb
    }()
    
    let endTimeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "End"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let endTimeTextField: TimePickerKeyboard = {
        let lb = TimePickerKeyboard()
        lb.layer.borderWidth = 0
        lb.layer.cornerRadius = 0
        lb.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return lb
    }()
    
    
    let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        lb.constraintWidth(equalToConstant: 60)
        lb.backgroundColor = .red
        lb.font = UIFont.boldSystemFont(ofSize: 12)
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
        bt.addTarget(self, action: #selector(tapMenu), for: .touchUpInside)
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
    
    let menuitemTagLabel: menuTagLabel = {
        let lb = menuTagLabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.backgroundColor = .blue
        lb.layer.cornerRadius = 12
        lb.clipsToBounds = true
        lb.textColor = .white
        lb.text = "Design"
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "$ 40.00"
        return lb
    }()
    
    let menuitemTagLabel2: menuTagLabel = {
        let lb = menuTagLabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lb.backgroundColor = .red
        lb.layer.cornerRadius = 12
        lb.clipsToBounds = true
        lb.textColor = .white
        lb.text = "Jel"
        return lb
    }()
    
    let priceLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "$ 40.00"
        return lb
    }()
    
    let tipsTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "tips"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let tipsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.constraintWidth(equalToConstant: 150)
        tf.constraintHeight(equalToConstant: 40)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    let memoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Memo"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()

    let memoTextView: MyTextView = {
        let tv = MyTextView()
        tv.constraintHeight(equalToConstant: 100)
        tv.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
}

extension NewReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            reportMainImageView.image = editedImage
            switch selectImageNum {
            case 0:
                reportImageViews[0].image = editedImage
            case 1:
                reportImageViews[1].image = editedImage
            case 2:
                reportImageViews[2].image = editedImage
            case 3:
                reportImageViews[3].image = editedImage
            default:
                print("---")
            }
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            reportImages.append(originalImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
