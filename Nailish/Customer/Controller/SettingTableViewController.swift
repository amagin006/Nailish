//
//  SettingTableViewController.swift
//  Nailish
//
//  Created by Shota Iwamoto on 2019-11-18.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit


class SettingTableViewController: UITableViewController {

    private let cellId = "SettingCell"



    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: cellId)


      
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "Menu Item Setting"
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(named: "White")
        cell.textLabel?.textColor = UIColor(named: "PrimaryText")
        let image = UIImage(named:"arrow")?.withRenderingMode(.alwaysTemplate)
        if let width = image?.size.width, let height = image?.size.height {
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            disclosureImageView.image = image
            cell.tintColor = UIColor(named: "PrimaryText")
            cell.accessoryView = disclosureImageView
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
