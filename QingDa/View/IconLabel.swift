//
//  IconLabel.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/16.
//

import UIKit

class IconLabel: CommonView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    
    @IBInspectable
    var size: CGFloat = 13 {
        didSet {
            titleLabel.font = titleLabel.font.withSize(size)
        }
    }
    
    @IBInspectable
    var space: CGFloat = 10 {
        didSet {
            spaceConstraint.constant = space
        }
    }
}
