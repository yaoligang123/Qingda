//
//  PointLabel.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/9.
//

import UIKit

class PointLabel: UILabel {
    
    open override var text: String? {
        didSet {
            if let text = text {
                let str = NSMutableAttributedString.init(string: tag == 0 ? "（" : "")
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"积分")
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                str.append(attachmentString)
                str.append(NSAttributedString(string: " " + text + (tag == 0 ? "）" : "")))
                attributedText = str
            }
        }
    }
}
