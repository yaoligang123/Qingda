//
//  BankCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit

class BankCell: UITableViewCell {
    
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var account: UILabel!
    var editAction: (() -> Void)? = nil
    
    func config(_ data: BankListResponse) {
        bankName.text = data.bankName
        account.text = data.account
    }
    
    @IBAction func edit() {
        editAction?()
    }
}
