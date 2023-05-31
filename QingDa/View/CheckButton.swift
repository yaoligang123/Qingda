//
//  CheckButton.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/10.
//

import UIKit

class CheckButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setImage(IMAGE("组 61991"), for: .normal)
        setImage(IMAGE("组 61990"), for: .selected)
    }
}
