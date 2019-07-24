//
//  SampleItem.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-07-23.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import Foundation

struct SampleItem {
    let color: String
    let menuName: String
    let price: String
}


extension SampleItem: Hashable {
  
    static func == (lhs: SampleItem, rhs: SampleItem) -> Bool {
        return lhs.color == rhs.color && lhs.menuName == rhs.menuName && lhs.price == rhs.price
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(menuName)
        hasher.combine(price)
    }
}
