//
//  MeCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/23.
//

import UIKit

class MeCell: CommonView {
    var tapAction: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBInspectable
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable
    var icon: String = "" {
        didSet {
            iconImageView.image = IMAGE(icon)
        }
    }
    
    @IBAction
    func tap() {
        self.tapAction?()
    }
}
