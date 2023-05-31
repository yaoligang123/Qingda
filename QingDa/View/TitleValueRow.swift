//
//  SettingRow.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class TitleValueRow: UIView, NibLoadable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var change: UIButton!
    var tapAction: (() -> Void)? = nil
    var btnAction: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib("TitleValueRow")
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib("TitleValueRow")
        common()
    }
    
    func common() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        stack.addGestureRecognizer(recognizer)
    }
    
    @IBAction
    func tap() {
        self.tapAction?()
    }
    
    @IBAction
    func btnTap() {
        self.btnAction?()
    }
}
