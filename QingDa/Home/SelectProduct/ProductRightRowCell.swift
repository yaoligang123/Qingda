//
//  RightRowCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class ProductRightRowCell: UITableViewCell {
    
    @IBOutlet weak var itemRow: ItemRow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ data:GetProductListData) {
        itemRow.title.text = data.title
        itemRow.reserve.isHidden = true
        itemRow.price.text = kUnit + data.price
        itemRow.thumbnail.load(data.thumbnail)
    }
    
}
