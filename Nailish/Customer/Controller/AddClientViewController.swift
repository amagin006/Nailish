//
//  AddClientViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-03.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData
import Photos

protocol AddClientViewControllerDelegate:class {
    func editClientDidFinish(client: ClientInfo)
    func deleteClientButtonPressed()
}

class AddClientViewController: UIViewController {
    
    weak var delegate: AddClientViewControllerDelegate?
    
    var client: ClientInfo! {
        didSet {
            firstNameTextField.text = client.firstName
            lastNameTextField.text = client.lastName ?? ""
            instagramTextField.text = client.instagram ?? ""
            twitterTextField.text = client.twitter ?? ""
            mailTextField.text = client.mailAdress ?? ""
            mobileTextField.text = client.mobileNumber ?? ""
            if let date = client?.dateOfBirth {
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY/MM/dd"
                DOBTextField.text = formatter.string(from: date)
            }
            memoTextField.text = client?.memo ?? ""
            if let image = client?.clientImage {
                personImageView.image = UIImage(data: image)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationUI()
        if client != nil {
            saveButton.isEnabled = true
        }
    }
    
    private func setupUI() {
        
        view.addSubview(clientFormView)
        clientFormView.backgroundColor = UIColor.init(red: 255/255, green: 235/255, blue: 154/255, alpha: 1)
        clientFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        clientFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        clientFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        clientFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        clientFormView.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: clientFormView.topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        headerView.backgroundColor = UIColor.init(red: 255/255, green: 235/255, blue: 154/255, alpha: 1)
        
        headerView.addSubview(personImageView)
        personImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        personImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        clientFormView.addSubview(addClientImage)
        addClientImage.contentMode = .center
        addClientImage.bottomAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8).isActive = true
        addClientImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addClientImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addClientImage.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: -8).isActive = true
        
        // FirstName column
        firstNameTextField.addTarget(self, action: #selector(firstNameValidation), for: .editingChanged)
        let firstNameTitleSV = UIStackView(arrangedSubviews: [firstNameIcon, firstNameLabel, requireLabel])
        firstNameTitleSV.axis = .horizontal
        firstNameTitleSV.spacing = 5
        firstNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let firstNameSV = UIStackView(arrangedSubviews: [firstNameTitleSV, firstNameTextField])
        firstNameSV.axis = .horizontal
        firstNameSV.alignment = .center
        firstNameSV.spacing = 10
        
        let firstNameView = UIView()
        clientFormView.addSubview(firstNameView)
        firstNameView.addBorders(edges: [.top, .bottom], color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        firstNameView.translatesAutoresizingMaskIntoConstraints = false
        firstNameView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        firstNameView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        firstNameView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        firstNameView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        firstNameView.backgroundColor = .white
        
        firstNameView.addSubview(firstNameSV)
        firstNameSV.translatesAutoresizingMaskIntoConstraints = false
        firstNameSV.topAnchor.constraint(equalTo: firstNameView.topAnchor).isActive = true
        firstNameSV.leadingAnchor.constraint(equalTo: firstNameView.leadingAnchor, constant: 10).isActive = true
        firstNameSV.trailingAnchor.constraint(equalTo: firstNameView.trailingAnchor, constant: -10).isActive = true
        firstNameSV.bottomAnchor.constraint(equalTo: firstNameView.bottomAnchor).isActive = true

        // Last Name Column
        let lastNameSV = UIStackView(arrangedSubviews: [lastNameLabel, lastNameTextField])
        lastNameSV.axis = .horizontal
        lastNameSV.alignment = .center
        lastNameSV.distribution = .fillProportionally
        lastNameSV.spacing = 10
        lastNameTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let lastNameView = UIView()
        clientFormView.addSubview(lastNameView)
        lastNameView.addBorders(edges: .bottom, color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        lastNameView.translatesAutoresizingMaskIntoConstraints = false
        lastNameView.topAnchor.constraint(equalTo: firstNameView.bottomAnchor).isActive = true
        lastNameView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        lastNameView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        lastNameView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        lastNameView.backgroundColor = .white
        
        lastNameView.addSubview(lastNameSV)
        lastNameSV.translatesAutoresizingMaskIntoConstraints = false
        lastNameSV.topAnchor.constraint(equalTo: lastNameView.topAnchor).isActive = true
        lastNameSV.leadingAnchor.constraint(equalTo: lastNameView.leadingAnchor, constant: 38).isActive = true
        lastNameSV.trailingAnchor.constraint(equalTo: lastNameView.trailingAnchor, constant: -10).isActive = true
        lastNameSV.bottomAnchor.constraint(equalTo: lastNameView.bottomAnchor).isActive = true
        
        // instagram Column
        let instagramSV = UIStackView(arrangedSubviews: [instagramImageView, instagramLabel, instagramTextField])
        instagramSV.axis = .horizontal
        instagramSV.alignment = .center
        instagramSV.spacing = 10
        
        let instagramView = UIView()
        clientFormView.addSubview(instagramView)
        instagramView.addBorders(edges: .bottom, color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        instagramView.translatesAutoresizingMaskIntoConstraints = false
        instagramView.topAnchor.constraint(equalTo: lastNameView.bottomAnchor).isActive = true
        instagramView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        instagramView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        instagramView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        instagramView.backgroundColor = .white
        
        instagramView.addSubview(instagramSV)
        instagramSV.translatesAutoresizingMaskIntoConstraints = false
        instagramSV.topAnchor.constraint(equalTo: instagramView.topAnchor).isActive = true
        instagramSV.leadingAnchor.constraint(equalTo: instagramView.leadingAnchor, constant: 10).isActive = true
        instagramSV.trailingAnchor.constraint(equalTo: instagramView.trailingAnchor, constant: -10).isActive = true
        instagramSV.bottomAnchor.constraint(equalTo: instagramView.bottomAnchor).isActive = true
        
        // twitter Column
        let twitterSV = UIStackView(arrangedSubviews: [twitterImageView, twitterLabel, twitterTextField])
        twitterSV.axis = .horizontal
        twitterSV.alignment = .center
        twitterSV.spacing = 10
        
        let twitterView = UIView()
        clientFormView.addSubview(twitterView)
        twitterView.addBorders(edges: .bottom, color:UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        twitterView.translatesAutoresizingMaskIntoConstraints = false
        twitterView.topAnchor.constraint(equalTo: instagramView.bottomAnchor).isActive = true
        twitterView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        twitterView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        twitterView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        twitterView.backgroundColor = .white
        
        twitterView.addSubview(twitterSV)
        twitterSV.translatesAutoresizingMaskIntoConstraints = false
        twitterSV.topAnchor.constraint(equalTo: twitterView.topAnchor).isActive = true
        twitterSV.leadingAnchor.constraint(equalTo: twitterView.leadingAnchor, constant: 10).isActive = true
        twitterSV.trailingAnchor.constraint(equalTo: twitterView.trailingAnchor, constant: -10).isActive = true
        twitterSV.bottomAnchor.constraint(equalTo: twitterView.bottomAnchor).isActive = true
        
        // mail Column
        let mailSV = UIStackView(arrangedSubviews: [mailImageView, mailLabel, mailTextField])
        mailSV.axis = .horizontal
        mailSV.alignment = .center
        mailSV.spacing = 10
        
        let mailView = UIView()
        clientFormView.addSubview(mailView)
        mailView.addBorders(edges: .bottom, color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        mailView.translatesAutoresizingMaskIntoConstraints = false
        mailView.topAnchor.constraint(equalTo: twitterView.bottomAnchor).isActive = true
        mailView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        mailView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        mailView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        mailView.backgroundColor = .white
        
        mailView.addSubview(mailSV)
        mailSV.translatesAutoresizingMaskIntoConstraints = false
        mailSV.topAnchor.constraint(equalTo: mailView.topAnchor).isActive = true
        mailSV.leadingAnchor.constraint(equalTo: mailView.leadingAnchor, constant: 10).isActive = true
        mailSV.trailingAnchor.constraint(equalTo: mailView.trailingAnchor, constant: -10).isActive = true
        mailSV.bottomAnchor.constraint(equalTo: mailView.bottomAnchor).isActive = true
        
        // mobile Column
        let mobileSV = UIStackView(arrangedSubviews: [mobileImageView, mobileLabel, mobileTextField])
        mobileSV.axis = .horizontal
        mobileSV.alignment = .center
        mobileSV.spacing = 10
        
        let mobileView = UIView()
        clientFormView.addSubview(mobileView)
        mobileView.addBorders(edges: .bottom, color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        mobileView.translatesAutoresizingMaskIntoConstraints = false
        mobileView.topAnchor.constraint(equalTo: mailView.bottomAnchor).isActive = true
        mobileView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        mobileView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        mobileView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        mobileView.backgroundColor = .white
        
        mobileView.addSubview(mobileSV)
        mobileSV.translatesAutoresizingMaskIntoConstraints = false
        mobileSV.topAnchor.constraint(equalTo: mobileView.topAnchor).isActive = true
        mobileSV.leadingAnchor.constraint(equalTo: mobileView.leadingAnchor, constant: 10).isActive = true
        mobileSV.trailingAnchor.constraint(equalTo: mobileView.trailingAnchor, constant: -10).isActive = true
        mobileSV.bottomAnchor.constraint(equalTo: mobileView.bottomAnchor).isActive = true
        
        //DOB Column
        let dobSV = UIStackView(arrangedSubviews: [DOBImageView, DOBLabel, DOBTextField])
        dobSV.axis = .horizontal
        dobSV.alignment = .center
        dobSV.spacing = 10
        
        let dobView = UIView()
        clientFormView.addSubview(dobView)
        dobView.addBorders(edges: .bottom, color: UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1), width: 1)
        dobView.translatesAutoresizingMaskIntoConstraints = false
        dobView.topAnchor.constraint(equalTo: mobileView.bottomAnchor).isActive = true
        dobView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        dobView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dobView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        dobView.backgroundColor = .white
        
        dobView.addSubview(dobSV)
        dobSV.translatesAutoresizingMaskIntoConstraints = false
        dobSV.topAnchor.constraint(equalTo: dobView.topAnchor).isActive = true
        dobSV.leadingAnchor.constraint(equalTo: dobView.leadingAnchor, constant: 10).isActive = true
        dobSV.trailingAnchor.constraint(equalTo: dobView.trailingAnchor, constant: -10).isActive = true
        dobSV.bottomAnchor.constraint(equalTo: dobView.bottomAnchor).isActive = true
        
        // memo Column
        let memoTitleSV = UIStackView(arrangedSubviews: [memoImageView, memoLabel])
        memoTitleSV.axis = .horizontal
        memoTitleSV.spacing = 10
        memoTitleSV.alignment = .center
        
        memoTextField.delegate = memoTextField
        let memoSV = UIStackView(arrangedSubviews: [memoTitleSV, memoTextField])
        memoSV.axis = .vertical
        memoSV.spacing = 10
        
        let memoView = UIView()
        clientFormView.addSubview(memoView)
        memoView.translatesAutoresizingMaskIntoConstraints = false
        memoView.topAnchor.constraint(equalTo: dobView.bottomAnchor).isActive = true
        memoView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor).isActive = true
        memoView.leadingAnchor.constraint(equalTo: clientFormView.leadingAnchor).isActive = true
        memoView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        memoView.backgroundColor = .white
        
        memoView.addSubview(memoSV)
        memoSV.translatesAutoresizingMaskIntoConstraints = false
        memoSV.topAnchor.constraint(equalTo: memoView.topAnchor, constant: 20).isActive = true
        memoSV.leadingAnchor.constraint(equalTo: memoView.leadingAnchor, constant: 10).isActive = true
        memoSV.trailingAnchor.constraint(equalTo: memoView.trailingAnchor, constant: -10).isActive = true
        memoSV.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        if client != nil {
            clientFormView.addSubview(deleteButton)
            deleteButton.topAnchor.constraint(equalTo: memoSV.bottomAnchor, constant: 70).isActive = true
            deleteButton.widthAnchor.constraint(greaterThanOrEqualTo: clientFormView.widthAnchor, multiplier: 0.4).isActive = true
            deleteButton.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
            memoView.addBorders(edges: .bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), width: 1)
            clientFormView.contentSize.height = 1000
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func setupNavigationUI() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1)
        navigationItem.title = client == nil ? "Add Client": "Edit Client"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func firstNameValidation() {
        if firstNameTextField.text != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc func selectImage() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // handle authorized status
            self.editClientImage()
        default:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    self.editClientImage()
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
    
    func editClientImage() {
        let imagePickController = UIImagePickerController()
        imagePickController.delegate = self
        imagePickController.allowsEditing = true
        present(imagePickController, animated: true, completion: nil)
    }
    
    @objc func seveButtonPressed() {
        
        let manageContext = CoreDataManager.shared.persistentContainer.viewContext
        
        if client == nil {
            let newClient = NSEntityDescription.insertNewObject(forEntityName: "ClientInfo", into: manageContext)
            
            if let newClientImage = personImageView.image {
                let imageData = newClientImage.jpegData(compressionQuality: 0.8)
                newClient.setValue(imageData, forKey: "clientImage")
            }
            let firstNameUpper = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased
            let fullName = "\(firstNameUpper!) \(lastNameTextField.text ?? "")"
            let nameInitial = String(firstNameUpper?.first ?? "#")
            newClient.setValue(firstNameUpper, forKey: "firstName")
            newClient.setValue(lastNameTextField.text, forKey: "lastName")
            newClient.setValue(fullName, forKey: "fullName")
            newClient.setValue(nameInitial, forKey: "nameInitial")
            if let instagram = instagramTextField.text {
                let trimmedString = instagram.trimmingCharacters(in: .whitespacesAndNewlines)
                var noSpaceString = trimmedString.remove(characterSet: .whitespacesAndNewlines)
                if instagram.first == "@" {
                    noSpaceString = String(noSpaceString.dropFirst(1))
                }
                print(noSpaceString)
                newClient.setValue(noSpaceString, forKey: "instagram")
            }
            if let twitter = twitterTextField.text {
                let trimmedString = twitter.trimmingCharacters(in: .whitespacesAndNewlines)
                var noSpaceString = trimmedString.remove(characterSet: .whitespacesAndNewlines)
                if twitter.first == "@" {
                    noSpaceString = String(noSpaceString.dropFirst(1))
                }
                newClient.setValue(noSpaceString, forKey: "twitter")
            }
            newClient.setValue(mailTextField.text ?? "", forKey: "mailAdress")
            newClient.setValue(mobileTextField.text ?? "", forKey: "mobileNumber")
            if let DOB = DOBTextField.text {
                print("DOB new \(DOB)")
                if DOB == "" {
                    newClient.setValue(DOBTextField.toolbar.datePicker.date, forKey: "dateOfBirth")
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY/MM/dd"
                    newClient.setValue(formatter.date(from: DOB), forKey: "dateOfBirth")
                }
            }
            newClient.setValue(memoTextField.text ?? "" , forKey: "memo")
            do {
                try fetchedClientInfoResultsController.managedObjectContext.save()
            } catch let err {
                print("Saved new client failed - \(err)")
            }
            dismiss(animated: true)
        } else {
            let firstNameUpper = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased
            client.firstName = firstNameUpper
            client.nameInitial = String(client.firstName?.first ?? "#")
            client.lastName = lastNameTextField.text
            let fullName = "\(firstNameUpper!) \(lastNameTextField.text ?? "")"
            client.fullName = fullName
            client.mailAdress = mailTextField.text ?? ""
            if let instagram = instagramTextField.text {
                let trimmedString = instagram.trimmingCharacters(in: .whitespacesAndNewlines)
                var noSpaceString = trimmedString.remove(characterSet: .whitespaces)
                if instagram.first == "@" {
                    noSpaceString = String(noSpaceString.dropFirst(1))
                }
                client.instagram = noSpaceString
            }
            if let twitter = twitterTextField.text {
                let trimmedString = twitter.trimmingCharacters(in: .whitespacesAndNewlines)
                var noSpaceString = trimmedString.remove(characterSet: .whitespaces)
                if twitter.first == "@" {
                    noSpaceString = String(noSpaceString.dropFirst(1))
                }
                client.twitter = noSpaceString
            }
            client.mobileNumber = mobileTextField.text ?? ""
            if let DOB = DOBTextField.text {
                print("DOB old \(DOB)")
                if DOB == "" {
                    client.dateOfBirth = DOBTextField.toolbar.datePicker.date
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY/MM/dd"
                    client.dateOfBirth = formatter.date(from: DOB)
                }
            }
            client?.memo = memoTextField.text ?? ""
            if let image = personImageView.image {
                client?.clientImage = image.jpegData(compressionQuality: 0.8)
            }
            do {
                try fetchedClientInfoResultsController.managedObjectContext.save()
             } catch let err {
                print("Saved new client failed - \(err)")
            }
            dismiss(animated: true) { [unowned self] in
                self.delegate?.editClientDidFinish(client: self.client)
            }
        }
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func deleteClient() {
        let alert: UIAlertController = UIAlertController(title: "Delete Client", message: "Are you sure you want to delete client?", preferredStyle: .alert)

        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler:{
            (action: UIAlertAction!) in
            
            let managementContent = CoreDataManager.shared.persistentContainer.viewContext
            managementContent.delete(self.client)
            do {
                try self.fetchedClientInfoResultsController.managedObjectContext.save()
            } catch let err {
                print("failed delete client - \(err)")
            }
            self.delegate?.deleteClientButtonPressed()
            self.dismiss(animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (action: UIAlertAction!) in
            
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameHeight = keyboardSize.cgRectValue.height
        
        if !(firstNameTextField.isFirstResponder || lastNameTextField.isFirstResponder) {
            self.view.frame.origin.y = -keyboardFrameHeight
        }
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    lazy var fetchedClientInfoResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<ClientInfo> in
        let fetchRequest = NSFetchRequest<ClientInfo>(entityName: "ClientInfo")
        let nameInitialDescriptors = NSSortDescriptor(key: "nameInitial", ascending: true)
        let firstNameDescriptors = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [nameInitialDescriptors, firstNameDescriptors]
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "nameInitial", cacheName: nil)
        return frc
    }()
    
    // MARK: - UIParts
    let clientFormView: UIScrollView = {
        let vi = UIScrollView()
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.contentSize.height = 850
        return vi
    }()
    
    lazy var personImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        iv.layer.cornerRadius = 80
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(seveButtonPressed))
        bt.isEnabled = false
        bt.tintColor = .white
        return bt
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        bt.tintColor = .white
        return bt
    }()
    
    let addClientImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .white
        return iv
    }()
    
    let firstNameIcon: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "person3"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let firstNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "First Name"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let requireLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "*"
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = .red
        return lb
    }()
    
    let firstNameTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.placeholder = "First Name..."
        tf.textAlignment = .right
        return tf
    }()
    
    let lastNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Last Name"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let lastNameTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.placeholder = "Last Name..."
        tf.textAlignment = .right
        return tf
    }()
    
    let instagramImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "instagram2"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let instagramLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Instagram"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let instagramTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "example006"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.textAlignment = .right
        return tf
    }()
    
    let twitterImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "twitter"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let twitterLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Twitter"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let twitterTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "twitter"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.textAlignment = .right
        return tf
    }()
    
    let mailImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mail1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let mailLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Mail address"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let mailTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.placeholder = "example@example.com"
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.textAlignment = .right
        return tf
    }()
    
    let mobileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "phone1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let mobileLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Mobile Number"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let mobileTextField: MyNormalTextField = {
        let tf = MyNormalTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "000-000-0000"
        tf.keyboardType = UIKeyboardType.phonePad
        tf.textAlignment = .right
        return tf
    }()
    
    let DOBImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "birthday"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let DOBLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Date of Birth"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let DOBTextField: DatePickerKeyboard = {
        let tf = DatePickerKeyboard()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .right
        return tf
    }()
    
    let memoImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "editicon2"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let memoLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Memo"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let memoTextField: MyTextView = {
        let tv = MyTextView()
        tv.textColor = .lightGray
        tv.contentSize.height = 200
        return tv
    }()
    
    let deleteButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Delete Client", for: .normal)
        bt.backgroundColor = .red
        bt.addTarget(self, action: #selector(deleteClient), for: .touchUpInside)
        bt.layer.cornerRadius = 10
        return bt
    }()
}

extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            personImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            personImageView.image = originalImage
        }

        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
