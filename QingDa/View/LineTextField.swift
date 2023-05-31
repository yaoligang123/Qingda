//
//  LineTextField.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class LineTextField: UITextField, BottomLine {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = UIFont.init(name: ".PingFang SC", size: 16)
        self.textColor = HEX(kMainColor2)
    }
    
    
    override func draw(_ rect: CGRect) {
        drawLine(rect, lineHeight: 1, color: kSubColor3)
    }
}
       
