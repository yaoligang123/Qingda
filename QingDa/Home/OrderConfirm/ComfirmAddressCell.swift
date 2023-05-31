//
//  ComfirmAddressCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/9.
//

import UIKit

class ComfirmAddressCell: UITableViewCell {
    
    var tapAction: (() -> Void)? = nil
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: AddressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressView.name.text = "Nome do contato："
        addressView.time.text = "Telefone："
        addressView.time.textColor = addressView.name.textColor
        addressView.time.font = addressView.name.font
        addressView.address.text = "Endereço："
        addressView.gps.isHidden = true
    }
    
    @IBAction func address() {
        self.tapAction?()
    }
    
    func config(_ data: GetAddressListItemData) {
        addressView.name.text = "Nome do contato：" + data.personName
        addressView.time.text = "Telefone：" + data.personPhone
        addressView.address.text = "Endereço：" + data.address
    }
    
    func config(_ data: GetServerOrderData) {
        addressView.name.text = "Nome do contato：" + data.personName
        addressView.time.text = "Telefone：" + data.personPhone
        addressView.address.text = "Endereço：" + data.address
        addressLabel.isHidden = true
    }
}
