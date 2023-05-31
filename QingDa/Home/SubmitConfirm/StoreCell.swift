//
//  StoreCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

import UIKit

class StoreCell: UITableViewCell {
    
    @IBOutlet weak var address:AddressView!
    
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
    }
    
}
