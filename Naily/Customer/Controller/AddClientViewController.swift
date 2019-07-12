//
//  AddClientViewController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-03.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit
import CoreData

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
//            facebookTextField.text = client.facebook ?? ""
//            lineTextField.text = client.line ?? ""
            mailTextField.text = client.mailAdress ?? ""
            mobileTextField.text = client.mobileNumber ?? ""
            if let date = client?.dateOfBirth {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
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
        clientFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        clientFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        clientFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        clientFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.backgroundColor = .white
        clientFormView.addSubview(personImageView)
        personImageView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        personImageView.topAnchor.constraint(equalTo: clientFormView.topAnchor, constant: 20).isActive = true
        personImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        clientFormView.addSubview(addClientImage)
        addClientImage.contentMode = .center
        addClientImage.bottomAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8).isActive = true
        addClientImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addClientImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addClientImage.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: -8).isActive = true
        
        firstNameTextField.addTarget(self, action: #selector(firstNameChage), for: .editingChanged)
        let firstNameTitleSV = UIStackView(arrangedSubviews: [firstNameLabel, requireLabel])
        firstNameTitleSV.axis = .horizontal
        firstNameTitleSV.spacing = 2
        firstNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let firstNameStackView = UIStackView(arrangedSubviews: [firstNameTitleSV, firstNameTextField])
        firstNameStackView.axis = .vertical
        firstNameStackView.spacing = 6
        
        let lastNameStackView = UIStackView(arrangedSubviews: [lastNameLabel, lastNameTextField])
        lastNameStackView.axis = .vertical
        lastNameStackView.spacing = 6
        
        let nameStackView = UIStackView(arrangedSubviews: [firstNameStackView, lastNameStackView])
        nameStackView.axis = .horizontal
        nameStackView.distribution = .fillEqually
        nameStackView.spacing = 10
        
        let instagramSV = UIStackView(arrangedSubviews: [instagramImageView, instagramLabel, instagramTextField])
        instagramSV.axis = .horizontal
        instagramSV.alignment = .center
        instagramSV.spacing = 10
        
        let twitterSV = UIStackView(arrangedSubviews: [twitterImageView, twitterLabel, twitterTextField])
        twitterSV.axis = .horizontal
        twitterSV.alignment = .center
        twitterSV.spacing = 10
        
//        let facebookSV = UIStackView(arrangedSubviews: [facebookImageView, facebookLabel, facebookTextField])
//        facebookSV.axis = .horizontal
//        facebookSV.alignment = .center
//        facebookSV.spacing = 10
//
//        let lineSV = UIStackView(arrangedSubviews: [lineImageView, lineLabel, lineTextField])
//        lineSV.axis = .horizontal
//        lineSV.alignment = .center
//        lineSV.spacing = 10
        
        let snsSV = UIStackView(arrangedSubviews: [instagramSV, twitterSV])
        snsSV.axis = .vertical
        snsSV.spacing = 4
        
        let mobileSV = UIStackView(arrangedSubviews: [mobileLabel, mobileTextField])
        mobileSV.axis = .horizontal
        mobileSV.spacing = 10
        
        let dobSV = UIStackView(arrangedSubviews: [DOBLabel, DOBTextField])
        dobSV.axis = .horizontal
        dobSV.spacing = 10
        
        let mailSV = UIStackView(arrangedSubviews: [mailLabel, mailTextField])
        mailSV.axis = .vertical
        mailSV.spacing = 6
        
        let hStackView = UIStackView(arrangedSubviews: [nameStackView, snsSV, mailSV, mobileSV, dobSV, memoLabel, memoTextField])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        clientFormView.addSubview(hStackView)
        hStackView.axis = .vertical
        hStackView.backgroundColor = .white
        hStackView.distribution = .fillEqually
        
        hStackView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 20).isActive = true
        hStackView.widthAnchor.constraint(equalTo: clientFormView.widthAnchor, multiplier: 0.8).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 16
        
        if client != nil {
            clientFormView.addSubview(deleteButton)
            deleteButton.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 50).isActive = true
            deleteButton.widthAnchor.constraint(greaterThanOrEqualTo: clientFormView.widthAnchor, multiplier: 0.4).isActive = true
            deleteButton.centerXAnchor.constraint(equalTo: clientFormView.centerXAnchor).isActive = true
            clientFormView.contentSize.height = 900
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func setupNavigationUI() {
        navigationItem.title = client == nil ? "Add Client": "Edit Client"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func firstNameChage() {
        if firstNameTextField.text != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc func selectImage() {
        print("press selectImage")
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
                let imageData = newClientImage.jpegData(compressionQuality: 0.1)
                newClient.setValue(imageData, forKey: "clientImage")
            }
            let firstNameUpper = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased
            let fullName = "\(firstNameUpper!) \(lastNameTextField.text ?? "")"
            let nameInitial = String(firstNameUpper?.first ?? "#")
            newClient.setValue(firstNameUpper, forKey: "firstName")
            newClient.setValue(lastNameTextField.text, forKey: "lastName")
            newClient.setValue(fullName, forKey: "fullName")
            newClient.setValue(nameInitial, forKey: "nameInitial")
            newClient.setValue(instagramTextField.text ?? "", forKey: "instagram")
            newClient.setValue(twitterTextField.text ?? "", forKey: "twitter")
//            newClient.setValue(facebookTextField.text ?? "", forKey: "facebook")
//            newClient.setValue(lineTextField.text ?? "", forKey: "line")
            newClient.setValue(mailTextField.text ?? "", forKey: "mailAdress")
            newClient.setValue(mobileTextField.text ?? "", forKey: "mobileNumber")
            if DOBTextField.text != "" {
                newClient.setValue(DOBTextField.toolbar.datePicker.date, forKey: "dateOfBirth")
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
            client.instagram = instagramTextField.text ?? ""
            client.twitter = twitterTextField.text ?? ""
//            client.facebook = facebookTextField.text ?? ""
//            client.line = lineTextField.text ?? ""
            client.mobileNumber = mobileTextField.text ?? ""
            if DOBTextField.text != "" {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                client?.dateOfBirth = formatter.date(from: DOBTextField.text)
            }
            client?.memo = memoTextField.text ?? ""
            if let image = personImageView.image {
                client?.clientImage = image.jpegData(compressionQuality: 0.1)
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
        if mobileTextField.isFirstResponder || DOBTextField.isFirstResponder || memoTextField.isFirstResponder {
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrameHeight = keyboardSize.cgRectValue.height
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrameHeight
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if mobileTextField.isFirstResponder || DOBTextField.isFirstResponder || memoTextField.isFirstResponder {
            guard let userInfo = notification.userInfo else { return }
            print(userInfo)
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardFrame.height
            }
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
        vi.backgroundColor = UIColor(red: 123/255, green: 204/255, blue: 172/255, alpha: 1)
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.contentSize.height = 800
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
        return bt
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
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
    
    let firstNameTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "First Name..."
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
    
    let lastNameTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "Last Name..."
        return tf
    }()
    
    let instagramImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "instagram"))
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
    
    let instagramTextField: MyTextField = {
        let tf = MyTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "example006"
        tf.keyboardType = UIKeyboardType.emailAddress
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
    
    let twitterTextField: MyTextField = {
        let tf = MyTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "@twitter"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    
    let facebookImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "facebook"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let facebookLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Facebook"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let facebookTextField: MyTextField = {
        let tf = MyTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "Facebook ID"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    
    let lineImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "line"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    let lineLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Line"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let lineTextField: MyTextField = {
        let tf = MyTextField()
        tf.autocapitalizationType =  UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "Line ID"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    
    let mailLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Mail address"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let mailTextField: MyTextField = {
        let tf = MyTextField()
        tf.placeholder = "example@example.com"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    
    let mobileLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Mobile Number"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lb
    }()
    
    let mobileTextField: MyTextField = {
        let tf = MyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.placeholder = "000-000-0000"
        tf.keyboardType = UIKeyboardType.phonePad
        return tf
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
        tf.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .center
        return tf
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
        tv.constraintHeight(equalToConstant: 100)
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
