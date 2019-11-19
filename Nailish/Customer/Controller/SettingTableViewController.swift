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
        cell.textLabel?.text = "SOMETHING"
        cell.backgroundColor = UIColor(named: "White")
        cell.textLabel?.textColor = UIColor(named: "PrimaryText")

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " Setting"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }



}
