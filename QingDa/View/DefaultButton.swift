//
//  DefaultButton.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/1.
//

import UIKit

class DefaultButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    func common() {
        self.backgroundColor = HEX(kMainColor1)
        self.setTitleColor(.white, for: .normal)
    }
}
