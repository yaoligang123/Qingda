//
//  ProductSelectCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/8.
//

import UIKit

class ProductSelectCell: UICollectionViewCell {
    
    @IBOutlet weak var btn: UILabel!
    
    var select = false {
        didSet {
            btn.layer.cornerRadius = 18;
            if select {
                btn.layer.borderWidth = 1
                btn.layer.borderColor = HEX(kMainColor1).cgColor
                btn.backgroundColor = .white
                btn.textColor = HEX(kMainColor1)
            } else {
                btn.layer.borderWidth = 0
                btn.backgroundColor = HEX("#F7F7F7")
                btn.textColor = HEX(kMainColor2)
            }
        }
    }
    
    var disable = false {
        didSet {
            if disable {
                btn.layer.borderWidth = 0
                btn.backgroundColor = HEX("#F7F7F7")
                btn.textColor = HEX(kMainColor3)
            }
        }
    }
}
