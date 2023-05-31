//
//  ConfrimButton.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class ConfrimButton: UIButton {
    
    open override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? HEX(kMainColor1) : HEX(kSubColor4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
