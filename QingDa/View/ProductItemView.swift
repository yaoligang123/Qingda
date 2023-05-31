//
//  ProductItemView.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/9.
//

import UIKit

class ProductItemView: CommonView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var point: UILabel!
    
    override func commonInit() {
        point.text = "100"
    }
}
