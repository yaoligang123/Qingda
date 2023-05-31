//
//  LoadView.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/12.
//

import UIKit
import NVActivityIndicatorView

class LoadView: CommonView {
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var error: UIImageView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func commonInit() {
        indicator.type = .ballPulse
        indicator.color = HEX(kMainColor1)
    }
}
