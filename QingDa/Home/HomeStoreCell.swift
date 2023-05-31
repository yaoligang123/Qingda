//
//  HomeStoreCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/2.
//

import UIKit
import Kingfisher

class HomeStoreCell: UITableViewCell {
    
    @IBOutlet weak var address:AddressView!
    @IBOutlet weak var storeImg:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ data:StoreData) {
        address.name.text = data.name
        address.time.text = data.businessHours
        address.address.text = data.address
        storeImg.load(data.thumbnail)
    }
}
