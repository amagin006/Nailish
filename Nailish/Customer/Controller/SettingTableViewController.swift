//
//  SettingTableViewController.swift
//  
//
//  Created by Shota Iwamoto on 2019-12-25.
//

import UIKit
import Firebase

private let cellId = "SettingCell"

class SettingTableViewController: UITableViewController {

    let settingMenu = [
        ["logout"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return settingMenu.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return settingMenu[section].count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let label = UILabel()
        label.backgroundColor = UIColor(red: 217/255, green: 83/255, blue: 79/255, alpha: 0.8)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor(red: 230/255, green: 190/255, blue: 188/255, alpha: 0.8)
        cell.textLabel!.text = settingMenu[indexPath.section][indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            print("logout")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
}
