//
//  CommonView.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class CommonView: UIView, NibLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
        commonInit()
    }
    
    func commonInit() {
        
    }
}
