//
//  NewReportMenuTableViewCell.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-23.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class NewReportMenuTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "newReportMenuCell")
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupUI() {
        
    }
    
}
