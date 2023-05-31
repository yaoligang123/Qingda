//
//  BorderButton2.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/8.
//

import UIKit

class BorderButton2: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    func common() {
        self.layer.borderWidth = 1
        self.layer.borderColor = HEX(kMainColor1).cgColor
        self.setTitleColor(HEX(kMainColor1), for: .normal)
    }
}
