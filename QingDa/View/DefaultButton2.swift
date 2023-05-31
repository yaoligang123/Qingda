//
//  DefaultButton2.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/8.
//

import UIKit

class DefaultButton2: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    func common() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 3
        self.setTitleColor(HEX(kMainColor1), for: .normal)
    }

}
