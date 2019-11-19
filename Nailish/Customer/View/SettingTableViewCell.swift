//
//  SettingTableViewCell.swift
//  Nailish
//
//  Created by Shota Iwamoto on 2019-11-18.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
         let backgroundView = UIView()
           backgroundView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
           self.selectedBackgroundView = backgroundView
    }

}
