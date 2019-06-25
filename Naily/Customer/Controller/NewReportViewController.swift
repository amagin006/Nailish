//
//  NewReportViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-13.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

//protocol NewReportViewControllerDelegate:class {
//    func reportSavedPressed(report: ReportItem)
//}

class NewReportViewController: UIViewController {
    
//    weak var delegate: NewReportViewControllerDelegate?
    var reportImageViews = [UIImageView]()
    var reportImages = [UIImage]()
    var selectImageNum = 0
    var client: ClientInfo?
    
    var report: ReportItem? {
        didSet {
            
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
        formScrollView.contentSize.width = UIScreen.main.bounds.width

        formScrollView.addSubview(reportMainImageView)
        reportMainImageView.topAnchor.constraint(equalTo: formScrollView.topAnchor).isActive = true
        reportMainImageView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor).isActive = true
        reportMainImageView.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        reportMainImageView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        
        formScrollView.addSubview(subImageSV)
        subImageSV.distribution = .fillEqually
        subImageSV.spacing = 10
        subImageSV.topAnchor.constraint(equalTo: reportMainImageView.bottomAnchor, constant: 10).isActive = true
        subImageSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        subImageSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        subImageSV.heightAnchor.constraint(equalToConstant: 92).isActive = true
        
        for i in 0..<3 {
            
            let iv = UIImageView(image: #imageLiteral(resourceName: "imagePlaceholder"))
            
            iv.layer.borderWidth = 2
            iv.layer.borderColor = UIColor.lightGray.cgColor
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
            iv.tag = i
            reportImageViews.append(iv)
            reportImages.append(iv.image!)
            subImageSV.addArrangedSubview(iv)
        }
        
        let addImageButton = UIButton()
        addImageButton.setImage(#imageLiteral(resourceName: "addicon2"), for: .normal)
        addImageButton.addTarget(self, action: #selector(addNewImageSelect), for: .touchUpInside)
        
        subImageSV.addArrangedSubview(addImageButton)
        
        let priceSV = UIStackView(arrangedSubviews: [priceTitleLabel, priceTextField])
        priceSV.axis = .vertical
        priceSV.spacing = 5
        
        let tipsSV = UIStackView(arrangedSubviews: [tipsTitleLabel, tipsTextField])
        tipsSV.axis = .vertical
        tipsSV.spacing = 5
        
        let priceBoxSV = UIStackView(arrangedSubviews: [priceSV, tipsSV])
        priceBoxSV.axis = .horizontal
        priceBoxSV.distribution = .fillEqually
        priceBoxSV.spacing = 10
        
        let discriptionSV = UIStackView(arrangedSubviews: [
            vistTitleLabel, visitTextField, menuTitleLabel, menuTextField, priceBoxSV, memoLabel,
            memoTextView])
        discriptionSV.translatesAutoresizingMaskIntoConstraints = false
        discriptionSV.axis = .vertical
        discriptionSV.spacing = 3
        discriptionSV.alignment = .fill
        formScrollView.addSubview(discriptionSV)
        
        discriptionSV.topAnchor.constraint(equalTo: subImageSV.bottomAnchor, constant: 10).isActive = true
        discriptionSV.widthAnchor.constraint(equalTo: formScrollView.widthAnchor, multiplier: 0.9).isActive = true
        discriptionSV.centerXAnchor.constraint(equalTo: formScrollView.centerXAnchor).isActive = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    private func setupNavigationUI() {
        navigationItem.title = "New Report"
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

        let image = reportImages[(sender.view?.tag)!]
        selectImageNum = sender.view!.tag
        if image != UIImage(named: "imagePlaceholder") {
            reportMainImageView.image = image
        }
    }
    
    @objc func addNewImageSelect() {
        print("press selectImage")
        if reportImages[2] == UIImage(named: "imagePlaceholder"){
            let imagePickController = UIImagePickerController()
            imagePickController.delegate = self
            imagePickController.allowsEditing = true
            
            present(imagePickController, animated: true, completion: nil)
        }
    }
    
    @objc func reportCancelButtonPressed() {
        print("reportCancelButtonPressed")
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
            
            newReport.setValue(visitTextField.text ?? "", forKey: "visitDate")
            newReport.setValue(menuTextField.text ?? "", forKey: "menu")
            newReport.setValue(Int(priceTextField.text ?? ""), forKey: "price")
            newReport.setValue(Int(tipsTextField.text ?? ""), forKey: "tips")
            newReport.setValue(memoTextView.text ?? "", forKey: "memo")
            newReport.setValue(client, forKey: "client")
            do {
                try fetchedReportItemResultsController.managedObjectContext.save()
            } catch let err {
                print("failed save Report - \(err)")
            }
            dismiss(animated: true)
        }
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
        return iv
    }()
    
    let subImageSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let vistTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Visit Day"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()

    let visitTextField: DatePickerKeyboard = {
        let tf = DatePickerKeyboard()
        return tf
    }()
    
    let menuTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Menu"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let menuTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let priceTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "price"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let priceTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    let tipsTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "tips"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    let tipsTextField: MyTextField = {
        let tf = MyTextField()
        tf.font = UIFont.systemFont(ofSize: 18)
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
        tv.font = UIFont.systemFont(ofSize: 18)
       
        return tv
    }()

}

extension NewReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            reportMainImageView.image = editedImage
            for (index,imageView) in reportImageViews.enumerated() {
                if imageView.image == UIImage(named: "imagePlaceholder") {
                    imageView.image = editedImage
                    reportImages[index] = editedImage
                    break
                }
            }
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            reportImages.append(originalImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
