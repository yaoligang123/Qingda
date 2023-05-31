//
//  TagCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/16.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    var select: Bool = false {
        didSet {
            title.textColor = select ? HEX(kMainColor1) : HEX(kMainColor2)
            self.bgView.backgroundColor = select ? HEX("#FEEDE0") : HEX("#F7F7F7")
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!

}
