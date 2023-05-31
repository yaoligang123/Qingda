//
//  SubLabel.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/8.
//

import UIKit

class SubLabel: UILabel {

    open override var text: String? {
        didSet {
            if let text = text {
                let str = NSMutableAttributedString.init(string: "¥" + text)
                let descriptor = font.fontDescriptor
                if let size = descriptor.object(forKey: .size) as? Double {
                    str.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont.systemFont(ofSize: size - 8),
                                     range: NSRange.init(location: 0, length: 1))
                    attributedText = str
                }
            }
        }
    }

}
