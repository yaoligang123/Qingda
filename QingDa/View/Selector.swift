//
//  Selector.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/10.
//

import UIKit

class Selector: CommonView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBInspectable
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable
    var size: CGFloat = 16 {
        didSet {
            titleLabel.font = titleLabel.font.withSize(size)
        }
    }
    
    @IBInspectable
    var selected: Bool = false {
        didSet {
            titleLabel.textColor = selected ? HEX(kMainColor1) : HEX(kMainColor2)
            arrow.image = IMAGE(selected ? "组 61093" : "组 61093(1)")
        }
    }
    
    override func commonInit() {
        selected = false
    }
}

