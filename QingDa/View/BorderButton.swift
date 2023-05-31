//
//  BorderButton.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/2.
//

import UIKit

class BorderButton: UIButton {
    
    var borderColor: UIColor = HEX(kMainColor2) {
        didSet {
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
            self.setTitleColor(borderColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    func common() {
    }
}
