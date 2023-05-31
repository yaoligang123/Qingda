//
//  SelCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/22.
//

import UIKit

class SelCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    var itemSelected = false {
        didSet {
            name.textColor = itemSelected ? HEX(kMainColor1) : HEX(kMainColor2)
            name.backgroundColor = itemSelected ? HEX("FEEDE0") : HEX(kSubColor4)
        }
    }
    
    func config(_ data:PopSelItem) {
        name.text = data.title
    }
}
