//
//  SearchResultCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/2.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var itemRow: ItemRow!
    
    func config(_ data:GetProductListData) {
        itemRow.title.text = data.title
        itemRow.price.text = kUnit + data.price
        itemRow.reserve.isHidden = true
        itemRow.thumbnail.load(data.thumbnail)
    }
}
