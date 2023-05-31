//
//  ProductOrderAddressCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/19.
//

import UIKit

class ProductOrderAddressCell: UITableViewCell {
    
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var addressView: AddressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addressView.time.textColor = addressView.name.textColor
        addressView.gps.isHidden = true
    }
    
    func config(_ data:GetOrderDetils) {
        state.text = stringFromProductState(data.state)
        addressView.name.text = "Nome do contato：" + data.receiptPerson
        addressView.time.text = "Telefone：" + data.receiptPhone
        addressView.address.text = "Endereço：" + data.receiptAddress
    }
}
