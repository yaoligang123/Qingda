//
//  SettingRow.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class SettingRow: TitleValueRow, BottomLine {
    
    @IBInspectable
    var showArrow = false {
        didSet {
            arrow.isHidden = !showArrow
        }
    }
    @IBInspectable
    var showChange = false {
        didSet {
            change.isHidden = !showChange
        }
    }
    @IBInspectable
    var showProfile = false {
        didSet {
            profile.isHidden = !showProfile
        }
    }
    override func common() {
        super.common()
        self.title.textColor = HEX(kMainColor2)
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawLine(rect, lineHeight: 0.5, color: kSubColor3)
    }
}
